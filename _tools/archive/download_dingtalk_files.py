#!/usr/bin/env python3
"""
钉钉聊天文件批量下载脚本
从所有会话（群聊+单聊）中拉取历史消息，提取文件附件，下载到本地。
按 人/群名 > 日期 组织，自动去重。

用法:
    python download_dingtalk_files.py
"""

import sys
import json
import subprocess
import os
import re
import time
import hashlib
from pathlib import Path
from typing import List, Any, Optional, Dict, Tuple

# ======================== 配置 ========================
OUTPUT_DIR = r"D:\myfiles\钉钉同步"
PROGRESS_FILE = os.path.join(OUTPUT_DIR, "_download_progress.json")
LOG_FILE = os.path.join(OUTPUT_DIR, "_download_log.txt")

# dws 命令完整路径
DWS_CMD = os.path.expanduser(r"~\.qoderworkcn\bin\dws.cmd")

# 每页拉取消息数
MSG_PAGE_SIZE = 50
# 每次 API 调用间隔（秒），避免限流
API_DELAY = 0.5
# 最大翻页次数（每个会话）
MAX_PAGES_PER_CONV = 200
# list-all 最大翻页数
MAX_LIST_ALL_PAGES = 500
# 时间范围：从很早到未来
START_TIME = "2020-01-01 00:00:00"
END_TIME = "2027-12-31 23:59:59"

# 已下载文件的记录
downloaded_files: Dict[str, Any] = {}
# 已发现的会话
conversations: Dict[str, Any] = {}
# 当前阶段进度
progress: Dict[str, Any] = {}


# ======================== 工具函数 ========================
def log(msg: str, level: str = "INFO"):
    """写日志到文件和终端"""
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] [{level}] {msg}"
    print(line)
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(line + "\n")
    except:
        pass


def run_dws(args: List[str], retries: int = 2) -> Optional[Any]:
    """执行 dws 命令并返回 JSON 结果"""
    cmd = [DWS_CMD] + args + ["--format", "json"]
    for attempt in range(retries + 1):
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
            if result.returncode != 0:
                stderr = result.stderr.strip()
                if "RECOVERY_EVENT_ID" in stderr:
                    log(f"Recovery event: {stderr}", "ERROR")
                    return None
                if attempt < retries:
                    log(f"重试 ({attempt+1}/{retries}): {' '.join(cmd[:6])}...", "WARN")
                    time.sleep(API_DELAY * 2)
                    continue
                log(f"dws 错误: {stderr}", "ERROR")
                return None
            return json.loads(result.stdout)
        except subprocess.TimeoutExpired:
            if attempt < retries:
                log(f"超时重试 ({attempt+1}/{retries})", "WARN")
                time.sleep(API_DELAY * 2)
                continue
            log("命令超时", "ERROR")
            return None
        except json.JSONDecodeError as e:
            log(f"JSON 解析错误: {e}", "ERROR")
            return None
        except FileNotFoundError:
            log("dws 命令未找到", "ERROR")
            return None
    return None


def safe_filename(name: str) -> str:
    """清理文件名中的非法字符"""
    # Windows 非法字符: < > : " / \ | ? *
    name = re.sub(r'[<>:"/\\|?*]', '_', name)
    # 去除头尾空格和点
    name = name.strip(" .")
    # 限制长度
    if len(name) > 100:
        base, ext = os.path.splitext(name)
        name = base[:100 - len(ext)] + ext
    return name or "unnamed"


def save_progress():
    """保存进度到文件"""
    data = {
        "phase": progress.get("phase", ""),
        "conversations": conversations,
        "downloaded_file_ids": list(downloaded_files.keys()),
        "list_all_cursor": progress.get("list_all_cursor", "0"),
        "list_all_page": progress.get("list_all_page", 0),
        "current_conv_idx": progress.get("current_conv_idx", 0),
        "current_conv_id": progress.get("current_conv_id", ""),
        "stats": progress.get("stats", {}),
    }
    try:
        with open(PROGRESS_FILE, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
    except Exception as e:
        log(f"保存进度失败: {e}", "ERROR")


def load_progress() -> bool:
    """加载之前的进度"""
    global conversations, downloaded_files, progress
    if not os.path.exists(PROGRESS_FILE):
        return False
    try:
        with open(PROGRESS_FILE, "r", encoding="utf-8") as f:
            data = json.load(f)
        conversations = data.get("conversations", {})
        downloaded_files = {fid: True for fid in data.get("downloaded_file_ids", [])}
        progress = {
            "phase": data.get("phase", ""),
            "list_all_cursor": data.get("list_all_cursor", "0"),
            "list_all_page": data.get("list_all_page", 0),
            "current_conv_idx": data.get("current_conv_idx", 0),
            "current_conv_id": data.get("current_conv_id", ""),
            "stats": data.get("stats", {}),
        }
        log(f"已加载进度: 阶段={progress['phase']}, 会话={len(conversations)}, 已下载={len(downloaded_files)}")
        return True
    except Exception as e:
        log(f"加载进度失败: {e}", "ERROR")
        return False


# ======================== 阶段1: 发现所有会话 ========================
def phase1_discover_conversations():
    """通过 message list-all 发现所有会话"""
    global conversations
    log("=" * 60)
    log("阶段1: 发现所有会话")
    log("=" * 60)

    cursor = progress.get("list_all_cursor", "0")
    page = progress.get("list_all_page", 0)

    while page < MAX_LIST_ALL_PAGES:
        log(f"  拉取 list-all 第 {page+1} 页, cursor={cursor[:30]}...")
        time.sleep(API_DELAY)

        data = run_dws([
            "chat", "message", "list-all",
            "--start", START_TIME,
            "--end", END_TIME,
            "--limit", str(MSG_PAGE_SIZE),
            "--cursor", cursor,
        ])

        if not data:
            log("  list-all 返回空，重试一次...", "WARN")
            time.sleep(2)
            data = run_dws([
                "chat", "message", "list-all",
                "--start", START_TIME,
                "--end", END_TIME,
                "--limit", str(MSG_PAGE_SIZE),
                "--cursor", cursor,
            ])
            if not data:
                log("  重试仍失败，保存进度", "ERROR")
                break

        result = data.get("result", data)
        conv_list = result.get("conversationMessagesList", [])
        has_more = result.get("hasMore", False)
        next_cursor = result.get("nextCursor", "")

        new_convs = 0
        for conv in conv_list:
            conv_id = conv.get("openConversationId", "")
            if conv_id and conv_id not in conversations:
                conversations[conv_id] = {
                    "title": conv.get("title", "未知会话"),
                    "singleChat": conv.get("singleChat", False),
                    "convId": conv_id,
                }
                new_convs += 1

        page += 1
        cursor = next_cursor
        progress["list_all_cursor"] = cursor
        progress["list_all_page"] = page
        progress["phase"] = "phase1"

        if page % 10 == 0:
            save_progress()
            log(f"  已发现 {len(conversations)} 个会话 (第{page}页, 新增{new_convs})")

        if not has_more or not next_cursor:
            log(f"  list-all 完成，无更多数据")
            break

    save_progress()
    log(f"阶段1完成: 共发现 {len(conversations)} 个会话")


# ======================== 阶段2: 扫描文件消息 ========================
def extract_file_info(content: str) -> Optional[Tuple[str, str]]:
    """从消息内容中提取文件名和 fileId"""
    # 格式: [文件] filename fileId: XXXXX
    match = re.search(r'\[文件\]\s*(.+?)\s+fileId:\s*(\S+)', content)
    if match:
        return (match.group(1).strip(), match.group(2).strip())
    return None


def phase2_scan_and_download_files():
    """对每个会话拉取消息，提取文件并下载"""
    log("=" * 60)
    log("阶段2: 扫描消息并下载文件")
    log("=" * 60)

    conv_list = list(conversations.values())
    start_idx = progress.get("current_conv_idx", 0)
    total = len(conv_list)
    stats = progress.get("stats", {
        "total_files_found": 0,
        "total_files_downloaded": 0,
        "total_files_skipped": 0,
        "total_files_failed": 0,
        "convs_processed": 0,
    })

    for idx in range(start_idx, total):
        conv = conv_list[idx]
        conv_id = conv["convId"]
        conv_title = conv.get("title", "未知会话")
        is_single = conv.get("singleChat", False)
        conv_type = "单聊" if is_single else "群聊"

        log(f"\n[{idx+1}/{total}] 处理 {conv_type}: {conv_title}")
        progress["current_conv_idx"] = idx
        progress["current_conv_id"] = conv_id

        # 用于记录该会话找到的文件
        conv_files = []

        # 拉取该会话所有消息（用 message list 从很早开始，forward=true）
        current_time = START_TIME
        page = 0
        while page < MAX_PAGES_PER_CONV:
            time.sleep(API_DELAY)

            cmd_args = [
                "chat", "message", "list",
                "--group", conv_id,
                "--time", current_time,
                "--limit", "200",
            ]

            data = run_dws(cmd_args)
            if not data:
                log(f"  拉取消息失败, 跳过该会话", "WARN")
                break

            result = data.get("result", data)
            messages = result.get("messages", [])
            has_more = result.get("hasMore", False)

            if not messages:
                break

            # 扫描文件消息
            for msg in messages:
                content = msg.get("content", "")
                if "[文件]" in content:
                    file_info = extract_file_info(content)
                    if file_info:
                        filename, file_id = file_info
                        create_time = msg.get("createTime", "")
                        sender = msg.get("sender", "未知")
                        conv_files.append({
                            "filename": filename,
                            "fileId": file_id,
                            "createTime": create_time,
                            "sender": sender,
                            "convTitle": conv_title,
                            "isSingle": is_single,
                        })

            page += 1
            if not has_more:
                break

            # 翻页: 用最后一条消息的 createTime
            last_time = messages[-1].get("createTime", "")
            if not last_time or last_time == current_time:
                break
            current_time = last_time

            if page % 10 == 0:
                log(f"    已扫描 {page} 页消息, 找到 {len(conv_files)} 个文件...")

        log(f"  该会话共找到 {len(conv_files)} 个文件")
        stats["total_files_found"] += len(conv_files)
        stats["convs_processed"] += 1

        # 下载文件
        for fi in conv_files:
            download_file(fi, stats)

        # 每处理5个会话保存一次进度
        if (idx + 1) % 5 == 0:
            progress["stats"] = stats
            save_progress()
            log(f"  --- 进度: {idx+1}/{total} 会话, "
                f"发现{stats['total_files_found']}文件, "
                f"下载{stats['total_files_downloaded']}, "
                f"跳过{stats['total_files_skipped']}, "
                f"失败{stats['total_files_failed']} ---")

    progress["stats"] = stats
    progress["phase"] = "phase2_done"
    save_progress()
    log(f"\n阶段2完成!")
    log(f"  总会话: {stats['convs_processed']}")
    log(f"  发现文件: {stats['total_files_found']}")
    log(f"  已下载: {stats['total_files_downloaded']}")
    log(f"  跳过(去重): {stats['total_files_skipped']}")
    log(f"  失败: {stats['total_files_failed']}")


def download_file(fi: Dict, stats: Dict):
    """下载单个文件到本地"""
    file_id = fi["fileId"]
    filename = fi["filename"]
    create_time = fi["createTime"]
    conv_title = fi["convTitle"]

    # 去重: 检查 fileId 是否已下载
    if file_id in downloaded_files:
        stats["total_files_skipped"] += 1
        return

    # 确定目标目录: OUTPUT_DIR / 会话名 / 日期 /
    date_str = "未知日期"
    if create_time:
        try:
            date_part = create_time.split(" ")[0]
            # 验证日期格式
            parts = date_part.split("-")
            if len(parts) == 3:
                date_str = f"{parts[0]}-{parts[1]}-{parts[2]}"
        except:
            pass

    folder_name = safe_filename(conv_title)
    target_dir = os.path.join(OUTPUT_DIR, folder_name, date_str)
    os.makedirs(target_dir, exist_ok=True)

    # 处理同名文件
    safe_name = safe_filename(filename)
    target_path = os.path.join(target_dir, safe_name)

    # 如果文件已存在（同名但不同 fileId），加后缀
    if os.path.exists(target_path):
        base, ext = os.path.splitext(safe_name)
        counter = 1
        while os.path.exists(target_path):
            target_path = os.path.join(target_dir, f"{base}_{counter}{ext}")
            counter += 1

    # Step 1: 获取下载链接
    time.sleep(API_DELAY)
    dl_data = run_dws(["drive", "download", "--file-id", file_id])
    if not dl_data:
        log(f"    获取下载链接失败: {filename}", "ERROR")
        stats["total_files_failed"] += 1
        return

    result = dl_data.get("result", dl_data)
    download_url = result.get("resourceUrl", "") or result.get("url", "")
    if not download_url:
        log(f"    无下载链接: {filename}", "ERROR")
        stats["total_files_failed"] += 1
        return

    # Step 2: 用 curl 下载
    try:
        curl_cmd = ["curl", "-sS", "-L", "-o", target_path, download_url]
        dl_result = subprocess.run(curl_cmd, capture_output=True, text=True, timeout=300)
        if dl_result.returncode != 0:
            log(f"    下载失败 (curl): {filename} - {dl_result.stderr.strip()}", "ERROR")
            stats["total_files_failed"] += 1
            return

        # 验证下载
        if os.path.exists(target_path) and os.path.getsize(target_path) > 0:
            downloaded_files[file_id] = {
                "filename": filename,
                "path": target_path,
                "size": os.path.getsize(target_path),
                "createTime": create_time,
            }
            stats["total_files_downloaded"] += 1
            log(f"    ✓ 已下载: {filename} ({os.path.getsize(target_path)} bytes)")
        else:
            log(f"    下载文件为空: {filename}", "ERROR")
            stats["total_files_failed"] += 1
            if os.path.exists(target_path):
                os.remove(target_path)
    except subprocess.TimeoutExpired:
        log(f"    下载超时: {filename}", "ERROR")
        stats["total_files_failed"] += 1
    except Exception as e:
        log(f"    下载异常: {filename} - {e}", "ERROR")
        stats["total_files_failed"] += 1


# ======================== 主流程 ========================
def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    log("=" * 60)
    log("钉钉聊天文件批量下载工具")
    log(f"输出目录: {OUTPUT_DIR}")
    log("=" * 60)

    # 尝试加载进度
    resumed = load_progress()
    if resumed:
        log("检测到之前的进度，将断点续传")

    # 阶段1: 发现所有会话
    if progress.get("phase") in ("", "phase1"):
        phase1_discover_conversations()
    else:
        log(f"跳过阶段1 (已完成, {len(conversations)} 个会话)")

    # 阶段2: 扫描消息并下载文件
    phase2_scan_and_download_files()

    log("\n全部完成!")
    log(f"文件保存在: {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
