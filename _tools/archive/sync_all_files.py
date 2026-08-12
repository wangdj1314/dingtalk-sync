#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
钉钉全量文件下载器
=================
扫描所有会话，提取文件消息，下载到本地。
按 人/群名 > 日期 组织，支持断点续传和去重。

用法:
    python sync_all_files.py
"""

import json
import os
import re
import subprocess
import sys
import time
import traceback
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

# ── 配置 ──
BASE_DIR = r"D:\myfiles\钉钉同步"
STATE_DIR = os.path.join(BASE_DIR, "_sync_state")
PROGRESS_FILE = os.path.join(STATE_DIR, "scan_progress.json")
MANIFEST_FILE = os.path.join(STATE_DIR, "file_manifest.json")
CONVS_FILE = os.path.join(BASE_DIR, "_all_convs.json")
DOWNLOAD_DIR = BASE_DIR
MAX_PAGES_PER_CONV = 50       # 每个会话最多翻页数
MSG_PAGE_SIZE = 200            # 每页消息数
DOWNLOAD_WORKERS = 3           # 并行下载数
DWS_CMD = r"C:\Users\wangdj\.qoderworkcn\bin\dws.cmd"
DWS_TIMEOUT = 60               # dws 命令超时(秒)
RATE_LIMIT_SLEEP = 0.3         # API 调用间隔(秒)

ILLEGAL_CHARS = re.compile(r'[<>:"/\\|?*\x00-\x1f]')


# ── 工具函数 ──
def safe_name(name):
    """清理文件名中的非法字符"""
    name = ILLEGAL_CHARS.sub("_", name).strip(" .")
    if len(name) > 120:
        base, ext = os.path.splitext(name)
        name = base[:120 - len(ext)] + ext
    return name or "unnamed"


def safe_dir(name):
    """清理目录名"""
    name = ILLEGAL_CHARS.sub("_", name).strip(" .")
    if len(name) > 80:
        name = name[:80]
    return name or "unknown"


def run_dws(args, timeout=DWS_TIMEOUT):
    """执行 dws 命令并返回 JSON 结果"""
    cmd = [DWS_CMD] + args
    try:
        result = subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout
        )
        if result.returncode != 0:
            stderr = result.stderr.strip()
            if stderr:
                return {"_error": stderr, "_code": result.returncode}
            # 有时错误信息在 stdout
            try:
                d = json.loads(result.stdout)
                if d.get("error"):
                    return {"_error": d["error"].get("message", str(d["error"]))}
                return d
            except:
                return {"_error": f"exit code {result.returncode}"}
        return json.loads(result.stdout)
    except subprocess.TimeoutExpired:
        return {"_error": "timeout"}
    except json.JSONDecodeError:
        return {"_error": "invalid JSON"}
    except FileNotFoundError:
        return {"_error": "dws not found"}
    except Exception as e:
        return {"_error": str(e)}


def load_progress():
    """加载扫描进度"""
    try:
        with open(PROGRESS_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return {"scanned_convs": {}, "all_files": []}


def save_progress(progress):
    """保存扫描进度"""
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(PROGRESS_FILE, "w", encoding="utf-8") as f:
        json.dump(progress, f, ensure_ascii=False, indent=2)


def load_manifest():
    """加载下载清单"""
    try:
        with open(MANIFEST_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return []


def save_manifest(manifest):
    """保存下载清单"""
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(MANIFEST_FILE, "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)


def load_downloaded():
    """加载已下载的 fileId 集合"""
    progress_file = os.path.join(STATE_DIR, "downloaded.json")
    try:
        with open(progress_file, "r", encoding="utf-8") as f:
            return set(json.load(f))
    except (FileNotFoundError, json.JSONDecodeError):
        return set()


def save_downloaded(downloaded):
    """保存已下载的 fileId"""
    progress_file = os.path.join(STATE_DIR, "downloaded.json")
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(progress_file, "w", encoding="utf-8") as f:
        json.dump(list(downloaded), f)


# ── Phase 1: 获取会话的 spaceId ──
def get_space_id(conv_id, title, single_chat):
    """获取会话的 IM 文件 spaceId"""
    data = run_dws(["chat", "conversation-info", "--group", conv_id])
    if "_error" in data:
        return None
    info = data.get("result", {}).get("conversationInfo", {})
    ext = info.get("extension", {})
    return ext.get("newCSpaceIdIM")


# ── Phase 2: 扫描会话中的所有文件消息 ──
def scan_conversation(conv, space_id):
    """扫描单个会话的所有消息，返回文件列表"""
    conv_id = conv["convId"]
    title = conv["title"]
    files = []
    time_cursor = "2020-01-01 00:00:00"

    for page in range(MAX_PAGES_PER_CONV):
        time.sleep(RATE_LIMIT_SLEEP)
        data = run_dws([
            "chat", "message", "list",
            "--group", conv_id,
            "--time", time_cursor,
            "--limit", str(MSG_PAGE_SIZE)
        ])

        if "_error" in data:
            print(f"    [ERROR] page {page}: {data['_error']}")
            break

        result = data.get("result", {})
        messages = result.get("messages", [])
        has_more = result.get("hasMore", False)

        for msg in messages:
            content = msg.get("content", "")
            if "fileId: " not in content:
                continue

            # 解析 fileId 和文件名
            parts = content.split("fileId: ")
            if len(parts) < 2:
                continue
            fid = parts[1].split()[0] if parts[1].split() else ""
            fn_part = parts[0].strip()
            fn = fn_part.split("] ", 1)[1].strip() if "] " in fn_part else fn_part

            if fid:
                files.append({
                    "fileId": fid,
                    "filename": fn,
                    "createTime": msg.get("createTime", ""),
                    "sender": msg.get("sender", ""),
                    "convId": conv_id,
                    "convTitle": title,
                    "spaceId": space_id,
                })

        if not has_more or not messages:
            break

        # 翻页: 取最后一条消息的 createTime
        last_time = messages[-1].get("createTime", "")
        if last_time and last_time != time_cursor:
            time_cursor = last_time
        else:
            break

    return files


# ── Phase 3: 获取下载链接并下载 ──
def get_download_url(file_id, space_id):
    """获取文件下载链接"""
    data = run_dws([
        "drive", "download",
        "--file-id", file_id,
        "--space-id", space_id
    ])
    if "_error" in data:
        return None
    result = data.get("result", {})
    return result.get("downloadUrl")


def download_file(url, target_path):
    """用 curl 下载文件"""
    try:
        r = subprocess.run(
            ["curl", "-sS", "-L", "--connect-timeout", "30",
             "--max-time", "120", "-o", target_path, url],
            capture_output=True, text=True, timeout=150,
        )
        if r.returncode == 0 and os.path.exists(target_path) and os.path.getsize(target_path) > 0:
            return True
        if os.path.exists(target_path):
            os.remove(target_path)
        return False
    except Exception:
        if os.path.exists(target_path):
            os.remove(target_path)
        return False


# ── 主流程 ──
def main():
    print(f"[{datetime.now():%H:%M:%S}] 钉钉全量文件下载器启动")
    print(f"  输出目录: {BASE_DIR}")
    print(f"  会话清单: {CONVS_FILE}")

    # 加载会话列表
    if not os.path.exists(CONVS_FILE):
        print(f"[ERROR] 找不到会话清单: {CONVS_FILE}")
        sys.exit(1)

    with open(CONVS_FILE, "r", encoding="utf-8") as f:
        convs = json.load(f)

    print(f"  会话总数: {len(convs)}")

    # 加载进度
    progress = load_progress()
    scanned_convs = progress.get("scanned_convs", {})
    all_files = progress.get("all_files", [])
    downloaded = load_downloaded()

    print(f"  已扫描会话: {len(scanned_convs)}")
    print(f"  已发现文件: {len(all_files)}")
    print(f"  已下载文件: {len(downloaded)}")

    # ── Phase 1+2: 扫描所有会话 ──
    print(f"\n{'='*60}")
    print(f"Phase 1+2: 扫描会话获取 fileId")
    print(f"{'='*60}")

    new_files = []
    scan_count = 0
    error_count = 0

    for i, conv in enumerate(convs):
        conv_id = conv["convId"]
        title = conv["title"]
        single = conv.get("singleChat", False)

        # 跳过已扫描的会话
        if conv_id in scanned_convs:
            continue

        scan_count += 1
        conv_type = "单聊" if single else "群聊"
        print(f"  [{i+1}/{len(convs)}] {title} ({conv_type})...", end=" ", flush=True)

        # 获取 spaceId
        space_id = get_space_id(conv_id, title, single)
        if not space_id:
            print("SKIP (no spaceId)")
            scanned_convs[conv_id] = {
                "title": title,
                "spaceId": None,
                "fileCount": 0,
                "scannedAt": datetime.now().isoformat(),
            }
            save_progress(progress)
            continue

        # 扫描消息
        files = scan_conversation(conv, space_id)
        new_files.extend(files)

        scanned_convs[conv_id] = {
            "title": title,
            "spaceId": space_id,
            "fileCount": len(files),
            "scannedAt": datetime.now().isoformat(),
        }

        all_files.extend(files)
        progress["scanned_convs"] = scanned_convs
        progress["all_files"] = all_files
        save_progress(progress)

        print(f"OK: {len(files)} files, spaceId={space_id}")
        time.sleep(RATE_LIMIT_SLEEP)

    print(f"\n  本次扫描: {scan_count} 个会话")
    print(f"  新发现: {len(new_files)} 个文件")
    print(f"  总计: {len(all_files)} 个文件")

    # ── Phase 3: 去重并构建下载清单 ──
    print(f"\n{'='*60}")
    print(f"Phase 3: 构建下载清单")
    print(f"{'='*60}")

    # 按 fileId 去重
    seen_ids = set()
    unique_files = []
    for f in all_files:
        fid = f["fileId"]
        if fid not in seen_ids:
            seen_ids.add(fid)
            unique_files.append(f)

    print(f"  去重前: {len(all_files)} 个文件")
    print(f"  去重后: {len(unique_files)} 个文件")

    # 过滤已下载的
    to_download = [f for f in unique_files if f["fileId"] not in downloaded]
    print(f"  待下载: {len(to_download)} 个文件 (已下载 {len(downloaded)})")

    if not to_download:
        print("\n  所有文件已下载完毕!")
        return

    # ── Phase 4: 下载文件 ──
    print(f"\n{'='*60}")
    print(f"Phase 4: 下载文件 ({len(to_download)} 个)")
    print(f"{'='*60}")

    ok_count = 0
    fail_count = 0
    skip_count = 0
    expire_count = 0

    for idx, file_info in enumerate(to_download):
        fid = file_info["fileId"]
        fname = file_info["filename"]
        space_id = file_info["spaceId"]
        title = safe_dir(file_info["convTitle"])
        create_time = file_info.get("createTime", "")

        # 按日期组织
        if create_time and len(create_time) >= 10:
            date_str = create_time[:10]
        else:
            date_str = "unknown"

        target_dir = os.path.join(DOWNLOAD_DIR, title, date_str)
        os.makedirs(target_dir, exist_ok=True)

        target_name = safe_name(fname)
        target_path = os.path.join(target_dir, target_name)

        # 处理同名文件
        if os.path.exists(target_path):
            base, ext = os.path.splitext(target_path)
            c = 1
            while os.path.exists(f"{base}_{c}{ext}"):
                c += 1
            target_path = f"{base}_{c}{ext}"

        # 获取下载链接
        time.sleep(RATE_LIMIT_SLEEP)
        url = get_download_url(fid, space_id)

        if not url:
            expire_count += 1
            print(f"  [{idx+1}/{len(to_download)}] EXPIRED/FAIL: {fname}")
            continue

        # 下载
        success = download_file(url, target_path)
        if success:
            sz = os.path.getsize(target_path)
            downloaded.add(fid)
            ok_count += 1
            print(f"  [{idx+1}/{len(to_download)}] OK: {fname} ({sz:,} bytes)")
        else:
            fail_count += 1
            print(f"  [{idx+1}/{len(to_download)}] FAIL: {fname}")

        # 每 10 个保存进度
        if (idx + 1) % 10 == 0:
            save_downloaded(downloaded)

    save_downloaded(downloaded)

    # ── 汇总 ──
    print(f"\n{'='*60}")
    print(f"下载完成!")
    print(f"{'='*60}")
    print(f"  会话总数:   {len(convs)}")
    print(f"  扫描会话:   {len(scanned_convs)}")
    print(f"  发现文件:   {len(unique_files)} (去重后)")
    print(f"  本次下载:   {ok_count}")
    print(f"  已过期:     {expire_count}")
    print(f"  下载失败:   {fail_count}")
    print(f"  累计已下载: {len(downloaded)}")
    print(f"  输出目录:   {DOWNLOAD_DIR}")


if __name__ == "__main__":
    main()
