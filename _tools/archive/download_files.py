#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
钉钉文件下载器
=============
从 JSON 清单文件读取下载任务，用 curl 下载到本地。
由 QoderWork 扫描阶段生成清单，本脚本只负责下载（不依赖 dws）。

用法:
    python download_files.py <清单文件.json>

清单文件格式:
    [
      {
        "downloadUrl": "https://...",     # 临时下载链接 (dws drive download 获取)
        "targetDir": "D:/.../群名/2026-06-06",
        "fileId": "xxx",
        "filename": "报告.pdf"
      },
      ...
    ]

输出:
    下载的文件保存到 targetDir/filename
    进度保存到 清单文件.progress.json
    日志输出到终端
"""

import json
import os
import re
import subprocess
import sys
import time
from datetime import datetime

ILLEGAL_CHARS = re.compile(r'[<>:"/\\|?*\x00-\x1f]')


def safe_name(name: str) -> str:
    name = ILLEGAL_CHARS.sub("_", name).strip(" .")
    if len(name) > 120:
        base, ext = os.path.splitext(name)
        name = base[:120 - len(ext)] + ext
    return name or "unnamed"


def load_progress(progress_file: str) -> set:
    """加载已下载的 fileId 集合"""
    try:
        with open(progress_file, "r", encoding="utf-8") as f:
            return set(json.load(f))
    except (FileNotFoundError, json.JSONDecodeError):
        return set()


def save_progress(progress_file: str, downloaded: set):
    with open(progress_file, "w", encoding="utf-8") as f:
        json.dump(list(downloaded), f)


def main():
    if len(sys.argv) < 2:
        print("用法: python download_files.py <清单文件.json>")
        sys.exit(1)

    manifest_path = sys.argv[1]
    progress_file = manifest_path + ".progress.json"

    with open(manifest_path, "r", encoding="utf-8") as f:
        tasks = json.load(f)

    if not tasks:
        print("清单为空，无需下载")
        return

    downloaded = load_progress(progress_file)
    total = len(tasks)
    ok = skip = fail = 0

    print(f"[{datetime.now().strftime('%H:%M:%S')}] 开始下载 {total} 个文件 (已完成 {len(downloaded)})")

    for i, task in enumerate(tasks):
        fid = task.get("fileId", "")
        fname = task.get("filename", "unknown")
        url = task.get("downloadUrl", "")
        target_dir = task.get("targetDir", "")

        # 去重
        if fid in downloaded:
            skip += 1
            continue

        if not url or not target_dir:
            fail += 1
            print(f"  [{i+1}/{total}] SKIP (无链接): {fname}")
            continue

        # 准备目录
        os.makedirs(target_dir, exist_ok=True)
        target_path = os.path.join(target_dir, safe_name(fname))

        # 处理同名
        if os.path.exists(target_path):
            base, ext = os.path.splitext(target_path)
            c = 1
            while os.path.exists(f"{base}_{c}{ext}"):
                c += 1
            target_path = f"{base}_{c}{ext}"

        # curl 下载
        try:
            r = subprocess.run(
                ["curl", "-sS", "-L", "--connect-timeout", "30",
                 "--max-time", "120", "-o", target_path, url],
                capture_output=True, text=True, timeout=150,
            )
            if r.returncode == 0 and os.path.exists(target_path) and os.path.getsize(target_path) > 0:
                sz = os.path.getsize(target_path)
                downloaded.add(fid)
                ok += 1
                print(f"  [{i+1}/{total}] OK: {fname} ({sz:,} bytes)")
            else:
                fail += 1
                print(f"  [{i+1}/{total}] FAIL: {fname}")
                if os.path.exists(target_path):
                    os.remove(target_path)
        except Exception as e:
            fail += 1
            print(f"  [{i+1}/{total}] ERROR: {fname} - {e}")

        # 定期保存进度
        if (i + 1) % 10 == 0:
            save_progress(progress_file, downloaded)

    save_progress(progress_file, downloaded)
    print(f"\n[{datetime.now().strftime('%H:%M:%S')}] 完成! 下载 {ok}, 跳过 {skip}, 失败 {fail}")


if __name__ == "__main__":
    main()
