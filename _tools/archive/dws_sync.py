#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
钉钉同步工具 - DingTalk Sync
==============================
扫描钉钉会话中的文件消息并下载到本地，同时支持导出聊天记录为 CSV。

用法:
    python dws_sync.py                # 增量同步文件（最近7天）
    python dws_sync.py --full         # 全量扫描文件
    python dws_sync.py --days 30      # 扫描最近30天
    python dws_sync.py --scan-only    # 仅扫描文件不下载
    python dws_sync.py --dry-run      # 预览将要下载的文件
    python dws_sync.py --export-csv   # 导出聊天记录到 CSV
    python dws_sync.py --all          # 文件同步 + 聊天记录导出
    python dws_sync.py --status       # 查看同步状态

依赖:
    - Python 3.8+
    - dws CLI (QoderWork 自带，位于 ~/.qoderworkcn/bin/dws-ext/dws-core-windows-amd64.exe)

作者: QoderWork 自动生成
日期: 2026-06-06
"""

import argparse
import csv
import json
import os
import platform
import re
import subprocess
import sys
import time
import urllib.request
import urllib.error
from datetime import datetime, timedelta
from pathlib import Path

# ============================================================
# 配置
# ============================================================

# 同步目录（文件保存位置）
SYNC_DIR = Path(__file__).parent.resolve()
STATE_DIR = SYNC_DIR / "_sync_state"

# 数据文件
CONVS_FILE = SYNC_DIR / "_all_convs.json"
MANIFEST_FILE = STATE_DIR / "download_manifest.json"
SPACE_IDS_FILE = STATE_DIR / "space_ids.json"
SYNC_LOG_FILE = STATE_DIR / "sync.log"
CHAT_EXPORT_DIR = SYNC_DIR / "_chat_export"
CHAT_STATE_FILE = STATE_DIR / "chat_export_state.json"

# DWS 可执行文件路径
DWS_CORE = None  # 运行时自动检测

# 文件消息正则: [文件] filename.ext fileId: XXXXX
FILE_MSG_RE = re.compile(r"\[文件\]\s*(.+?)\s+fileId:\s*(\S+)")

# 单次请求间隔（秒），避免频率限制
REQUEST_INTERVAL = 0.3


# ============================================================
# 工具函数
# ============================================================

def ensure_dirs():
    """确保必要的目录存在"""
    STATE_DIR.mkdir(parents=True, exist_ok=True)


def log(msg, level="INFO"):
    """打印带时间戳的日志"""
    ts = datetime.now().strftime("%H:%M:%S")
    print(f"[{ts}] [{level}] {msg}", flush=True)


def write_log(msg):
    """写入同步日志文件"""
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(SYNC_LOG_FILE, "a", encoding="utf-8") as f:
        f.write(f"[{ts}] {msg}\n")


def find_dws_core():
    """自动检测 dws-core 可执行文件路径"""
    global DWS_CORE

    # 优先级: 环境变量 > QoderWork bin > 系统 PATH
    candidates = []

    # 1. 环境变量
    env_dws = os.environ.get("DWS_CORE_PATH")
    if env_dws:
        candidates.append(Path(env_dws))

    # 2. QoderWork bin 目录
    home = Path.home()
    qoderwork_bin = home / ".qoderworkcn" / "bin" / "dws-ext"

    system = platform.system()
    arch = platform.machine().lower()

    if system == "Windows":
        if "arm64" in arch:
            candidates.append(qoderwork_bin / "dws-core-windows-arm64.exe")
        candidates.append(qoderwork_bin / "dws-core-windows-amd64.exe")
    elif system == "Darwin":
        candidates.append(qoderwork_bin / "dws-core-darwin-amd64")
        candidates.append(qoderwork_bin / "dws-core-darwin-arm64")
    elif system == "Linux":
        candidates.append(qoderwork_bin / "dws-core-linux-amd64")
        candidates.append(qoderwork_bin / "dws-core-linux-arm64")

    # 3. 系统 PATH 中的 dws
    candidates.append(Path("dws"))

    for c in candidates:
        try:
            result = subprocess.run(
                [str(c), "--version"],
                capture_output=True, timeout=10
            )
            if result.returncode == 0:
                DWS_CORE = str(c)
                version = result.stdout.decode("utf-8", errors="replace").strip()
                log(f"找到 DWS: {DWS_CORE} ({version})")
                return True
        except (FileNotFoundError, subprocess.TimeoutExpired):
            continue

    log("未找到 dws-core 可执行文件！", "ERROR")
    log("请确保已安装 QoderWork 或设置 DWS_CORE_PATH 环境变量", "ERROR")
    return False


# ============================================================
# DWS 命令封装
# ============================================================

def dws_call(args, timeout=30):
    """
    调用 dws-core 命令，返回解析后的 JSON。
    如果失败返回 None。
    """
    if not DWS_CORE:
        log("DWS 未初始化", "ERROR")
        return None

    cmd = [DWS_CORE] + args
    try:
        result = subprocess.run(cmd, capture_output=True, timeout=timeout)

        # 尝试从 stdout 解析 JSON
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
        if stdout:
            try:
                return json.loads(stdout)
            except json.JSONDecodeError:
                pass

        # 尝试从 stderr 解析 JSON（错误信息有时在 stderr）
        stderr = result.stderr.decode("utf-8", errors="replace").strip()
        if stderr:
            try:
                return json.loads(stderr)
            except json.JSONDecodeError:
                pass

        if result.returncode != 0:
            return {"_error": True, "_message": stderr or stdout or f"exit code {result.returncode}"}

        return None

    except subprocess.TimeoutExpired:
        return {"_error": True, "_message": "命令超时"}
    except Exception as e:
        return {"_error": True, "_message": str(e)}


def list_messages(conv_id, start_time, limit=200):
    """
    获取会话消息列表。
    返回 (messages, has_more) 元组。
    """
    data = dws_call([
        "chat", "message", "list",
        "--group", conv_id,
        "--time", start_time,
        "--limit", str(limit)
    ], timeout=60)

    if not data or data.get("_error"):
        return [], False

    messages = data.get("result", {}).get("messages", [])
    # 判断是否还有更多消息：如果返回数量等于 limit，可能还有下一页
    has_more = len(messages) >= limit

    return messages, has_more


def get_conversation_info(conv_id):
    """获取会话信息，返回 (title, space_id)"""
    data = dws_call([
        "chat", "conversation-info",
        "--group", conv_id
    ])

    if not data or not isinstance(data, dict) or data.get("_error"):
        return None, None

    # 检查是否有 API 错误
    if "error" in data:
        return None, None

    conv_info = data.get("result", {}).get("conversationInfo", {})
    title = conv_info.get("title", "")
    ext = conv_info.get("extension", {})
    space_id = ext.get("newCSpaceIdIM", "")

    # 确保 space_id 是字符串
    if not isinstance(space_id, str):
        space_id = ""

    return title, space_id


def get_download_url(file_id, space_id):
    """获取文件下载 URL，失败返回 None"""
    data = dws_call([
        "drive", "download",
        "--file-id", file_id,
        "--space-id", space_id
    ])

    if not data or data.get("_error"):
        return None

    url = data.get("result", {}).get("downloadUrl", "")
    return url if url else None


# ============================================================
# 文件消息解析
# ============================================================

def extract_file_messages(messages):
    """
    从消息列表中提取文件消息。
    返回 [{fileId, filename, createTime, senderName}, ...]
    """
    files = []
    for msg in messages:
        # 防御性检查：跳过非 dict 类型的消息
        if not isinstance(msg, dict):
            continue
        content = msg.get("content", "")
        match = FILE_MSG_RE.search(content)
        if match:
            filename = match.group(1).strip()
            file_id = match.group(2).strip()
            # sender 字段可能是字符串或字典
            sender = msg.get("sender", "")
            if isinstance(sender, dict):
                sender = sender.get("name", "")
            files.append({
                "fileId": file_id,
                "filename": filename,
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
            })
    return files


# ============================================================
# 数据持久化
# ============================================================

def load_json(filepath, default=None):
    """加载 JSON 文件"""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return default if default is not None else []


def save_json(filepath, data):
    """保存 JSON 文件"""
    filepath = Path(filepath)
    filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(filepath, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def load_manifest():
    """加载下载清单，返回 {fileId: record} 字典"""
    records = load_json(MANIFEST_FILE, [])
    return {r["fileId"]: r for r in records if "fileId" in r}


def save_manifest(manifest_dict):
    """保存下载清单"""
    records = list(manifest_dict.values())
    save_json(MANIFEST_FILE, records)


def load_space_ids():
    """加载 spaceId 缓存"""
    return load_json(SPACE_IDS_FILE, {})


def save_space_ids(space_ids):
    """保存 spaceId 缓存"""
    save_json(SPACE_IDS_FILE, space_ids)


# ============================================================
# 下载功能
# ============================================================

def safe_filename(name):
    """将文件名转换为安全的文件名（移除不合法字符）"""
    # Windows 不合法字符
    unsafe = r'[<>:"/\\|?*]'
    name = re.sub(unsafe, '_', name)
    # 移除前后空格
    name = name.strip()
    # 截断过长文件名
    if len(name) > 200:
        base, ext = os.path.splitext(name)
        name = base[:200 - len(ext)] + ext
    return name


def safe_dirname(name):
    """将目录名转换为安全的目录名"""
    name = safe_filename(name)
    # 额外的目录名处理
    name = name.replace("/", "_").replace("\\", "_")
    return name or "unknown"


def download_file(url, dest_path, timeout=120):
    """
    从 URL 下载文件到指定路径。
    返回 True 表示成功，False 表示失败。
    """
    dest_path = Path(dest_path)
    dest_path.parent.mkdir(parents=True, exist_ok=True)

    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", "DingTalkSync/1.0")

        with urllib.request.urlopen(req, timeout=timeout) as response:
            # 写入临时文件，完成后重命名（原子操作）
            tmp_path = dest_path.with_suffix(dest_path.suffix + ".tmp")
            with open(tmp_path, "wb") as f:
                while True:
                    chunk = response.read(8192)
                    if not chunk:
                        break
                    f.write(chunk)
            tmp_path.rename(dest_path)
        return True

    except (urllib.error.URLError, urllib.error.HTTPError, OSError) as e:
        log(f"  下载失败: {e}", "WARN")
        # 清理临时文件
        tmp_path = dest_path.with_suffix(dest_path.suffix + ".tmp")
        if tmp_path.exists():
            tmp_path.unlink()
        return False


# ============================================================
# 核心同步逻辑
# ============================================================

def scan_conversation(conv_id, conv_title, start_time, space_ids_cache):
    """
    扫描单个会话的所有消息，返回发现的文件列表。
    同时更新 space_ids_cache。
    """
    files_found = []
    current_time = start_time
    page = 0

    while True:
        page += 1
        time.sleep(REQUEST_INTERVAL)

        messages, has_more = list_messages(conv_id, current_time)

        if not messages:
            break

        # 提取文件消息
        file_msgs = extract_file_messages(messages)
        for fm in file_msgs:
            fm["convId"] = conv_id
            fm["convTitle"] = conv_title
        files_found.extend(file_msgs)

        if not has_more:
            break

        # 更新游标到最后一条消息的时间
        last_time = messages[-1].get("createTime", "")
        if not last_time or last_time == current_time:
            break
        current_time = last_time

    # 获取 spaceId（如果发现了文件且缓存中没有）
    if files_found and conv_id not in space_ids_cache:
        time.sleep(REQUEST_INTERVAL)
        title, space_id = get_conversation_info(conv_id)
        if space_id:
            space_ids_cache[conv_id] = space_id

    return files_found


def run_sync(args):
    """执行同步"""

    ensure_dirs()

    # 加载会话列表
    convs = load_json(CONVS_FILE)
    if not convs:
        log(f"未找到会话列表: {CONVS_FILE}", "ERROR")
        log("请先在 QoderWork 中运行一次完整扫描", "ERROR")
        return 1

    log(f"加载了 {len(convs)} 个会话")

    # 计算起始时间
    if args.full:
        start_time = "2020-01-01 00:00:00"
        log("模式: 全量扫描（从 2020 年开始）")
    else:
        days = args.days or 7
        start_dt = datetime.now() - timedelta(days=days)
        start_time = start_dt.strftime("%Y-%m-%d %H:%M:%S")
        log(f"模式: 增量扫描（最近 {days} 天，从 {start_time} 开始）")

    # 加载已有清单
    manifest = load_manifest()
    existing_count = len(manifest)
    log(f"已有清单: {existing_count} 个文件")

    # 加载 spaceId 缓存
    space_ids = load_space_ids()

    # ========== 阶段 1: 扫描 ==========
    log("=" * 50)
    log("阶段 1: 扫描会话消息")
    log("=" * 50)

    new_files = []
    scanned = 0
    errors = 0

    for i, conv in enumerate(convs):
        conv_id = conv["convId"]
        conv_title = conv.get("title", conv_id[:20])
        scanned += 1

        # 扫描进度
        if (i + 1) % 5 == 0 or i == 0 or i == len(convs) - 1:
            log(f"  扫描中 [{i+1}/{len(convs)}] {conv_title}...")

        try:
            files = scan_conversation(conv_id, conv_title, start_time, space_ids)
            if files:
                log(f"  [{conv_title}] 发现 {len(files)} 个文件", "INFO")

            # 过滤已下载的文件
            for f in files:
                fid = f["fileId"]
                if fid not in manifest:
                    # 补充 spaceId
                    if conv_id in space_ids:
                        f["spaceId"] = space_ids[conv_id]
                    new_files.append(f)

        except Exception as e:
            log(f"  [{conv_title}] 扫描出错: {e}", "ERROR")
            errors += 1

    # 按 fileId 去重
    seen_ids = set(manifest.keys())
    unique_new = []
    for f in new_files:
        fid = f["fileId"]
        if fid not in seen_ids:
            seen_ids.add(fid)
            unique_new.append(f)

    log(f"扫描完成: {scanned} 个会话, 发现 {len(unique_new)} 个新文件, {errors} 个错误")

    if not unique_new:
        log("没有新文件需要同步")
        # 保存 spaceId 缓存
        save_space_ids(space_ids)
        write_log(f"扫描完成: 无新文件 (扫描 {scanned} 个会话)")
        return 0

    # 补充缺失的 spaceId
    need_space = [f for f in unique_new if "spaceId" not in f and f["convId"] not in space_ids]
    if need_space:
        convs_needing_space = set(f["convId"] for f in need_space)
        log(f"获取 {len(convs_needing_space)} 个会话的 spaceId...")
        for cid in convs_needing_space:
            time.sleep(REQUEST_INTERVAL)
            title, sid = get_conversation_info(cid)
            if sid:
                space_ids[cid] = sid

    # 为所有新文件补充 spaceId
    for f in unique_new:
        if "spaceId" not in f:
            cid = f["convId"]
            if cid in space_ids:
                f["spaceId"] = space_ids[cid]

    # 保存 spaceId 缓存
    save_space_ids(space_ids)

    # 将新文件加入清单
    for f in unique_new:
        manifest[f["fileId"]] = {
            "fileId": f["fileId"],
            "filename": f["filename"],
            "createTime": f.get("createTime", ""),
            "sender": f.get("senderName", ""),
            "convId": f["convId"],
            "convTitle": f.get("convTitle", ""),
            "spaceId": f.get("spaceId", ""),
        }

    # 保存清单
    save_manifest(manifest)
    log(f"清单已更新: {len(manifest)} 个文件")

    if args.scan_only:
        log("仅扫描模式，跳过下载")
        write_log(f"扫描完成: {len(unique_new)} 个新文件 (仅扫描)")
        return 0

    if args.dry_run:
        log("=" * 50)
        log("Dry-run 模式: 以下文件将被下载")
        log("=" * 50)
        for f in unique_new:
            ct = f.get("createTime", "")[:10]
            title = f.get("convTitle", "unknown")
            name = f["filename"]
            print(f"  {ct} | {title} | {name}")
        log(f"共 {len(unique_new)} 个文件")
        return 0

    # ========== 阶段 2: 下载 ==========
    log("=" * 50)
    log("阶段 2: 下载文件")
    log("=" * 50)

    downloaded = 0
    expired = 0
    failed = 0

    for i, f in enumerate(unique_new):
        fid = f["fileId"]
        fname = f["filename"]
        sid = f.get("spaceId", "")
        conv_title = f.get("convTitle", "unknown")
        create_time = f.get("createTime", "")

        # 构建目标路径: SYNC_DIR / 会话名 / 日期 / 文件名
        date_str = create_time[:10] if create_time else "unknown"
        safe_title = safe_dirname(conv_title)
        safe_name = safe_filename(fname)
        dest_dir = SYNC_DIR / safe_title / date_str
        dest_path = dest_dir / safe_name

        # 如果文件已存在，跳过
        if dest_path.exists():
            downloaded += 1
            log(f"  [{i+1}/{len(unique_new)}] 已存在: {safe_name}")
            continue

        # 获取下载链接
        progress = f"[{i+1}/{len(unique_new)}]"

        if not sid:
            log(f"  {progress} 无 spaceId，跳过: {fname}", "WARN")
            failed += 1
            continue

        time.sleep(REQUEST_INTERVAL)
        url = get_download_url(fid, sid)

        if not url:
            expired += 1
            log(f"  {progress} 已过期: {fname}")
            # 标记为已过期
            manifest[fid]["_expired"] = True
            continue

        # 下载文件
        log(f"  {progress} 下载中: {fname}...")
        ok = download_file(url, dest_path)

        if ok:
            downloaded += 1
            file_size = dest_path.stat().st_size
            size_str = format_size(file_size)
            log(f"  {progress} 完成: {safe_name} ({size_str})")
            manifest[fid]["_downloaded"] = True
            manifest[fid]["_localPath"] = str(dest_path)
        else:
            failed += 1
            manifest[fid]["_failed"] = True

        # 每 20 个文件保存一次清单
        if (i + 1) % 20 == 0:
            save_manifest(manifest)

    # 最终保存
    save_manifest(manifest)

    # ========== 结果汇总 ==========
    log("=" * 50)
    log("同步完成!")
    log(f"  新发现: {len(unique_new)} 个文件")
    log(f"  已下载: {downloaded}")
    log(f"  已过期: {expired}")
    log(f"  失败:   {failed}")
    log(f"  清单总计: {len(manifest)} 个文件")
    log("=" * 50)

    write_log(
        f"同步完成: 新{len(unique_new)}, 下载{downloaded}, "
        f"过期{expired}, 失败{failed}, 清单{len(manifest)}"
    )

    return 0


def format_size(size_bytes):
    """格式化文件大小"""
    if size_bytes < 1024:
        return f"{size_bytes} B"
    elif size_bytes < 1024 * 1024:
        return f"{size_bytes / 1024:.1f} KB"
    elif size_bytes < 1024 * 1024 * 1024:
        return f"{size_bytes / 1024 / 1024:.1f} MB"
    else:
        return f"{size_bytes / 1024 / 1024 / 1024:.1f} GB"


def show_status(args):
    """显示当前同步状态"""
    ensure_dirs()

    manifest = load_manifest()
    convs = load_json(CONVS_FILE)

    total = len(manifest)
    downloaded = sum(1 for r in manifest.values() if r.get("_downloaded"))
    expired = sum(1 for r in manifest.values() if r.get("_expired"))
    failed = sum(1 for r in manifest.values() if r.get("_failed"))
    pending = total - downloaded - expired - failed

    # 实际磁盘文件数
    disk_files = 0
    disk_size = 0
    for root, dirs, files in os.walk(SYNC_DIR):
        if "_sync_state" in root:
            continue
        for fn in files:
            fp = os.path.join(root, fn)
            try:
                disk_size += os.path.getsize(fp)
                disk_files += 1
            except OSError:
                pass

    print()
    print("=" * 50)
    print("  钉钉文件同步状态")
    print("=" * 50)
    print(f"  会话数:     {len(convs) if convs else 0}")
    print(f"  清单文件数: {total}")
    print(f"  已下载:     {downloaded}")
    print(f"  已过期:     {expired}")
    print(f"  失败:       {failed}")
    print(f"  待处理:     {pending}")
    print(f"  磁盘文件:   {disk_files} ({format_size(disk_size)})")
    print(f"  同步目录:   {SYNC_DIR}")
    print("=" * 50)

    # 最近同步日志
    if SYNC_LOG_FILE.exists():
        lines = SYNC_LOG_FILE.read_text(encoding="utf-8").strip().split("\n")
        if lines:
            print()
            print("最近日志:")
            for line in lines[-5:]:
                print(f"  {line}")

    print()


# ============================================================
# 聊天记录导出
# ============================================================

def classify_content(content):
    """判断消息类型"""
    if not content:
        return "empty", ""
    if content.startswith("[文件]"):
        return "file", content
    if content.startswith("[图片]"):
        return "image", content
    if content.startswith("[链接]") or content.startswith("[Link]"):
        return "link", content
    if content.startswith("[视频]"):
        return "video", content
    if content.startswith("[语音]"):
        return "audio", content
    if content.startswith("[名片]"):
        return "card", content
    if content.startswith("[日程]"):
        return "calendar", content
    if content.startswith("[DING"):
        return "ding", content
    if content.startswith("[已回复]") or content.startswith("[回复]"):
        return "reply", content
    return "text", content


def load_chat_state():
    """加载聊天导出状态 {convId: last_exported_time}"""
    return load_json(CHAT_STATE_FILE, {})


def save_chat_state(state):
    """保存聊天导出状态"""
    save_json(CHAT_STATE_FILE, state)


def export_conversation_csv(conv_id, conv_title, start_time, csv_path):
    """
    导出单个会话的聊天记录到 CSV。
    返回 (message_count, last_time) 元组。
    """
    all_messages = []
    current_time = start_time

    while True:
        time.sleep(REQUEST_INTERVAL)
        messages, has_more = list_messages(conv_id, current_time)

        if not messages:
            break

        for msg in messages:
            if not isinstance(msg, dict):
                continue
            sender = msg.get("sender", "")
            if isinstance(sender, dict):
                sender = sender.get("name", "")
            content = msg.get("content", "")
            msg_type, _ = classify_content(content)
            all_messages.append({
                "time": msg.get("createTime", ""),
                "sender": sender,
                "type": msg_type,
                "content": content,
            })

        if not has_more:
            break

        last_time = messages[-1].get("createTime", "")
        if not last_time or last_time == current_time:
            break
        current_time = last_time

    if not all_messages:
        return 0, start_time

    # 写入 CSV（追加模式，如果文件已存在）
    file_exists = csv_path.exists()
    csv_path.parent.mkdir(parents=True, exist_ok=True)

    with open(csv_path, "a", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["时间", "发送人", "类型", "内容"])
        for m in all_messages:
            writer.writerow([m["time"], m["sender"], m["type"], m["content"]])

    last_time = all_messages[-1]["time"]
    return len(all_messages), last_time


def run_export_csv(args):
    """执行聊天记录导出"""
    ensure_dirs()
    CHAT_EXPORT_DIR.mkdir(parents=True, exist_ok=True)

    convs = load_json(CONVS_FILE)
    if not convs:
        log(f"未找到会话列表: {CONVS_FILE}", "ERROR")
        return 1

    log(f"加载了 {len(convs)} 个会话")

    # 计算起始时间
    chat_state = load_chat_state()

    if args.full:
        start_time = "2020-01-01 00:00:00"
        log("导出模式: 全量（从 2020 年开始）")
    else:
        days = args.days or 7
        start_dt = datetime.now() - timedelta(days=days)
        start_time = start_dt.strftime("%Y-%m-%d %H:%M:%S")
        log(f"导出模式: 最近 {days} 天")

    log("=" * 50)
    log("导出聊天记录到 CSV")
    log(f"输出目录: {CHAT_EXPORT_DIR}")
    log("=" * 50)

    total_msgs = 0
    total_convs = 0
    errors = 0

    for i, conv in enumerate(convs):
        conv_id = conv["convId"]
        conv_title = conv.get("title", conv_id[:20])
        safe_title = safe_dirname(conv_title)

        # 确定起始时间：优先用上次导出位置
        conv_start = start_time
        if not args.full and conv_id in chat_state:
            saved_time = chat_state[conv_id]
            if saved_time > conv_start:
                conv_start = saved_time

        csv_path = CHAT_EXPORT_DIR / f"{safe_title}.csv"

        if (i + 1) % 10 == 0 or i == 0 or i == len(convs) - 1:
            log(f"  [{i+1}/{len(convs)}] {conv_title}...")

        try:
            count, last_time = export_conversation_csv(
                conv_id, conv_title, conv_start, csv_path
            )
            if count > 0:
                total_msgs += count
                total_convs += 1
                chat_state[conv_id] = last_time
                log(f"  [{conv_title}] 导出 {count} 条消息")
        except Exception as e:
            log(f"  [{conv_title}] 导出出错: {e}", "ERROR")
            errors += 1

        # 每 10 个会话保存一次状态
        if (i + 1) % 10 == 0:
            save_chat_state(chat_state)

    save_chat_state(chat_state)

    log("=" * 50)
    log("导出完成!")
    log(f"  导出会话: {total_convs}")
    log(f"  导出消息: {total_msgs}")
    log(f"  错误: {errors}")
    log(f"  输出目录: {CHAT_EXPORT_DIR}")
    log("=" * 50)

    write_log(f"CSV导出完成: {total_convs} 会话, {total_msgs} 消息, {errors} 错误")
    return 0


# ============================================================
# 入口
# ============================================================

def main():
    # Windows 终端 UTF-8
    if sys.platform == "win32":
        try:
            sys.stdout.reconfigure(encoding="utf-8")
            sys.stderr.reconfigure(encoding="utf-8")
        except Exception:
            pass

    parser = argparse.ArgumentParser(
        description="钉钉同步工具 - 文件下载 + 聊天记录导出",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  python dws_sync.py                  增量同步文件（最近7天）
  python dws_sync.py --full           全量扫描文件
  python dws_sync.py --days 30        扫描最近30天
  python dws_sync.py --scan-only      仅扫描文件，不下载
  python dws_sync.py --dry-run        预览将要下载的文件
  python dws_sync.py --export-csv     导出聊天记录到 CSV
  python dws_sync.py --all            同步文件 + 导出聊天记录
  python dws_sync.py --status         查看同步状态
        """
    )

    parser.add_argument("--full", action="store_true", help="全量扫描（从2020年开始）")
    parser.add_argument("--days", type=int, default=7, help="增量扫描天数（默认7天）")
    parser.add_argument("--scan-only", action="store_true", help="仅扫描文件，不下载")
    parser.add_argument("--dry-run", action="store_true", help="预览模式，不实际下载")
    parser.add_argument("--export-csv", action="store_true", help="导出聊天记录到 CSV")
    parser.add_argument("--all", action="store_true", help="同时执行文件同步和聊天记录导出")
    parser.add_argument("--status", action="store_true", help="显示同步状态")

    args = parser.parse_args()

    # 查找 DWS
    if not find_dws_core():
        return 1

    if args.status:
        show_status(args)
        return 0

    log("钉钉同步工具 v1.1")
    log(f"工作目录: {SYNC_DIR}")

    ret = 0

    # 文件同步
    if not args.export_csv or args.all:
        write_log(f"开始文件同步 (full={args.full}, days={args.days})")
        ret = run_sync(args)

    # 聊天记录导出
    if args.export_csv or args.all:
        ret2 = run_export_csv(args)
        if ret2 != 0:
            ret = ret2

    return ret


if __name__ == "__main__":
    sys.exit(main())
