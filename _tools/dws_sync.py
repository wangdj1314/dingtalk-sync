#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
钉钉同步工具 - DingTalk Sync
==============================
扫描钉钉会话中的文件消息和图片消息并下载到本地，同时支持导出聊天记录为 CSV。

用法:
    python dws_sync.py --init          # 首次运行，生成配置文件
    python dws_sync.py                 # 增量同步文件（最近7天）
    python dws_sync.py --full          # 全量扫描文件
    python dws_sync.py --days 30       # 扫描最近30天
    python dws_sync.py --scan-only     # 仅扫描文件不下载
    python dws_sync.py --dry-run       # 预览将要下载的文件
    python dws_sync.py --export-csv    # 导出聊天记录到 CSV
    python dws_sync.py --all           # 文件同步 + 聊天记录导出
    python dws_sync.py --status        # 查看同步状态

依赖:
    - Python 3.8+
    - dws CLI (QoderWork 自带，或手动指定路径)

配置文件:
    与脚本同目录的 config.json，首次运行 --init 自动生成。
    不同机器 / 不同账号只需修改配置文件即可。

作者: QoderWork 自动生成
日期: 2026-06-06
"""

import argparse
import csv
import hashlib
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
# 脚本位于 _tools/ 子目录，数据保存在上一级目录
SYNC_DIR = Path(__file__).parent.parent.resolve()
STATE_DIR = SYNC_DIR / "_sync_state"

# 数据文件
CONVS_FILE = SYNC_DIR / "_all_convs.json"
MANIFEST_FILE = STATE_DIR / "download_manifest.json"
SPACE_IDS_FILE = STATE_DIR / "space_ids.json"
SYNC_LOG_FILE = STATE_DIR / "sync.log"
CHAT_EXPORT_DIR = SYNC_DIR / "_chat_export"
CHAT_STATE_FILE = STATE_DIR / "chat_export_state.json"
IMAGE_MANIFEST_FILE = STATE_DIR / "image_manifest.json"
IMAGE_DIR = SYNC_DIR / "_images"
AUTH_STATE_FILE = STATE_DIR / "auth_state.json"

# 认证到期提前预警时间（小时）
AUTH_WARN_HOURS = 48
# 自动刷新超时（秒），超过则判定为等待交互输入
AUTH_LOGIN_TIMEOUT = 15

# DWS 可执行文件路径
DWS_CORE = None  # 运行时自动检测

# 文件消息正则: [文件] filename.ext fileId: XXXXX
FILE_MSG_RE = re.compile(r"\[文件\]\s*(.+?)\s+fileId:\s*(\S+)")

# 图片消息正则: [图片消息](mediaId=XXX) 或 [图片]
IMAGE_MSG_RE = re.compile(r"\[图片消息\]\(mediaId=([^\)]+)\)")
IMAGE_SIMPLE_RE = re.compile(r"\[图片\]")

# 单次请求间隔（秒），避免频率限制
REQUEST_INTERVAL = 0.3

# 配置文件路径（与脚本同目录）
TOOLS_DIR = Path(__file__).parent.resolve()
CONFIG_FILE = TOOLS_DIR / "config.json"


# ============================================================
# 配置文件管理
# ============================================================

def load_config():
    """
    加载配置文件 config.json，返回配置字典。
    如果文件不存在，返回 None。
    """
    if not CONFIG_FILE.exists():
        return None
    try:
        with open(CONFIG_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, OSError) as e:
        print(f"[ERROR] 配置文件读取失败: {CONFIG_FILE} - {e}", file=sys.stderr)
        return None


def init_config():
    """
    生成配置文件模板。如果已存在则提示并跳过。
    自动探测 dws-core、账号信息并预填。
    """
    if CONFIG_FILE.exists():
        print(f"配置文件已存在: {CONFIG_FILE}")
        print("如需重置，请先删除后重新运行 --init")
        return False

    # 自动检测当前环境
    system = platform.system()
    arch = platform.machine().lower()

    # 推测 DWS 路径
    home = Path.home()
    qoderwork_bin = home / ".qoderworkcn" / "bin" / "dws-ext"
    if system == "Windows":
        if "arm64" in arch:
            dws_name = "dws-core-windows-arm64.exe"
        else:
            dws_name = "dws-core-windows-amd64.exe"
    elif system == "Darwin":
        dws_name = "dws-core-darwin-arm64" if "arm64" in arch else "dws-core-darwin-amd64"
    else:
        dws_name = "dws-core-linux-arm64" if "arm64" in arch else "dws-core-linux-amd64"

    guessed_dws = str(qoderwork_bin / dws_name)
    if not Path(guessed_dws).exists():
        guessed_dws = ""

    # 默认同步目录：脚本上一级
    default_sync_dir = str(TOOLS_DIR.parent.resolve())

    # 尝试自动探测账号信息
    print("正在探测钉钉账号信息...")
    global DWS_CORE
    found_dws = find_dws_core(guessed_dws)

    acct_name = ""
    acct_desc = ""
    corp_id = ""
    if found_dws:
        info = detect_account_info()
        acct_name = info["name"]
        acct_desc = info["description"]
        corp_id = info["corp_id"]
        if acct_name:
            print(f"  已检测到: {acct_name} ({acct_desc})")
        else:
            print("  未能自动检测账号信息，请手动填写 account.name")
    else:
        print("  未找到 dws-core，账号信息需手动填写")

    config = {
        "version": 1,
        "account": {
            "name": acct_name,
            "description": acct_desc if acct_desc else "钉钉账号备注（可选，方便区分多账号）",
            "corp_id": corp_id
        },
        "paths": {
            "sync_dir": default_sync_dir,
            "convs_file": "_all_convs.json",
            "dws_core": guessed_dws,
            "chat_export_subdir": "_chat_export"
        },
        "defaults": {
            "days": 7,
            "request_interval": 0.3
        },
        "features": {
            "auto_download": True,
            "export_csv": False
        }
    }

    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        json.dump(config, f, ensure_ascii=False, indent=2)

    print(f"\n配置文件已生成: {CONFIG_FILE}")
    print()
    # 告知哪些需要手动改
    needs_edit = []
    if not acct_name:
        needs_edit.append("  account.name      → 填写你的名字")
    if not guessed_dws:
        needs_edit.append("  paths.dws_core    → 填写 dws-core 路径（留空则运行时自动检测）")
    needs_edit.append(f"  paths.sync_dir    → 确认同步目录（当前: {default_sync_dir}）")

    if needs_edit:
        print("请确认以下字段:")
        for line in needs_edit:
            print(line)
    else:
        print("所有字段已自动填写，可直接运行 python dws_sync.py 开始同步。")
    print()
    return True


def apply_config(config):
    """
    将配置文件中的值应用到全局变量。
    返回 (success, error_message)。
    """
    global SYNC_DIR, STATE_DIR, CONVS_FILE, MANIFEST_FILE, SPACE_IDS_FILE
    global SYNC_LOG_FILE, CHAT_EXPORT_DIR, CHAT_STATE_FILE, REQUEST_INTERVAL

    if not config:
        return False, "配置为空"

    paths = config.get("paths", {})

    # sync_dir: 绝对路径直接使用，相对路径基于脚本所在目录解析
    sync_dir_str = paths.get("sync_dir", "")
    if sync_dir_str:
        p = Path(sync_dir_str)
        if not p.is_absolute():
            p = (TOOLS_DIR / p).resolve()
        SYNC_DIR = p
    # 否则保持默认（脚本上一级目录）

    STATE_DIR = SYNC_DIR / "_sync_state"

    # convs_file: 相对于 SYNC_DIR 或绝对路径
    convs_str = paths.get("convs_file", "_all_convs.json")
    convs_path = Path(convs_str)
    if convs_path.is_absolute():
        CONVS_FILE = convs_path
    else:
        CONVS_FILE = SYNC_DIR / convs_str

    MANIFEST_FILE = STATE_DIR / "download_manifest.json"
    SPACE_IDS_FILE = STATE_DIR / "space_ids.json"
    SYNC_LOG_FILE = STATE_DIR / "sync.log"

    # chat_export_subdir
    export_subdir = paths.get("chat_export_subdir", "_chat_export")
    export_path = Path(export_subdir)
    if export_path.is_absolute():
        CHAT_EXPORT_DIR = export_path
    else:
        CHAT_EXPORT_DIR = SYNC_DIR / export_subdir

    CHAT_STATE_FILE = STATE_DIR / "chat_export_state.json"

    # defaults
    defaults = config.get("defaults", {})
    interval = defaults.get("request_interval", 0.3)
    if isinstance(interval, (int, float)) and interval >= 0:
        REQUEST_INTERVAL = interval

    return True, ""


def detect_account_info():
    """
    通过 dws-core 自动探测当前钉钉账号信息。
    返回 dict: {name, description, corp_id, org_name, dept_name, user_id}
    探测失败的字段会留空。
    """
    info = {
        "name": "",
        "description": "",
        "corp_id": "",
        "org_name": "",
        "dept_name": "",
        "user_id": "",
    }

    if not DWS_CORE:
        return info

    # 1. 获取当前用户信息
    try:
        result = subprocess.run(
            [DWS_CORE, "contact", "user", "get-self"],
            capture_output=True, timeout=15
        )
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
        if stdout and result.returncode == 0:
            data = json.loads(stdout)
            if data.get("success") and data.get("result"):
                user = data["result"][0]
                org = user.get("orgEmployeeModel", {})
                info["name"] = org.get("orgUserName", "")
                info["user_id"] = org.get("userId", "")
                info["org_name"] = org.get("orgName", "")
                info["corp_id"] = org.get("corpId", "")

                depts = org.get("depts", [])
                if depts:
                    info["dept_name"] = depts[0].get("deptName", "")

                # 拼接描述
                parts = []
                if info["org_name"]:
                    parts.append(info["org_name"])
                if info["dept_name"]:
                    parts.append(info["dept_name"])
                info["description"] = " / ".join(parts)
    except (subprocess.TimeoutExpired, json.JSONDecodeError, Exception) as e:
        log(f"自动探测账号信息失败: {e}", "WARN")

    # 2. 补充 corp_id（如果上面没拿到）
    if not info["corp_id"]:
        try:
            result = subprocess.run(
                [DWS_CORE, "auth", "status"],
                capture_output=True, timeout=10
            )
            stdout = result.stdout.decode("utf-8", errors="replace").strip()
            if stdout and result.returncode == 0:
                data = json.loads(stdout)
                info["corp_id"] = data.get("corp_id", "")
        except Exception:
            pass

    return info


def check_auth_status():
    """
    检查 DWS 认证状态。
    返回 dict:
      authenticated, token_valid, refresh_token_valid,
      expires_at, refresh_expires_at,
      hours_left, refresh_hours_left, error
    """
    result_info = {
        "authenticated": False,
        "token_valid": False,
        "refresh_token_valid": False,
        "expires_at": None,
        "refresh_expires_at": None,
        "hours_left": None,
        "refresh_hours_left": None,
        "error": None,
    }

    if not DWS_CORE:
        result_info["error"] = "DWS 未初始化"
        return result_info

    try:
        result = subprocess.run(
            [DWS_CORE, "auth", "status"],
            capture_output=True, timeout=10
        )
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
        if not stdout:
            result_info["error"] = "auth status 无输出"
            return result_info

        data = json.loads(stdout)
        result_info["authenticated"] = data.get("authenticated", False)
        result_info["token_valid"] = data.get("token_valid", False)
        result_info["refresh_token_valid"] = data.get("refresh_token_valid", False)
        result_info["expires_at"] = data.get("expires_at")
        result_info["refresh_expires_at"] = data.get("refresh_expires_at")

        now = datetime.now().astimezone()  # 带时区信息的当前时间

        # 解析 access token 过期时间
        exp_str = result_info["expires_at"]
        if exp_str:
            try:
                # 格式: 2026-06-10T11:15:43.5948566+08:00
                exp_dt = datetime.fromisoformat(exp_str)
                result_info["hours_left"] = (exp_dt - now).total_seconds() / 3600
            except (ValueError, TypeError, OverflowError):
                pass

        # 解析 refresh token 过期时间
        ref_exp_str = result_info["refresh_expires_at"]
        if ref_exp_str:
            try:
                ref_exp_dt = datetime.fromisoformat(ref_exp_str)
                result_info["refresh_hours_left"] = (ref_exp_dt - now).total_seconds() / 3600
            except (ValueError, TypeError, OverflowError):
                pass

    except subprocess.TimeoutExpired:
        result_info["error"] = "auth status 超时"
    except json.JSONDecodeError:
        result_info["error"] = "auth status 返回非 JSON"
    except Exception as e:
        result_info["error"] = str(e)

    return result_info


def try_auth_refresh():
    """
    尝试通过 dws auth login 自动刷新 token。
    如果 refresh token 有效，dws-core 会静默刷新并快速返回。
    如果 refresh token 已过期，dws 会进入交互模式等待扫码，
    我们设置短超时来避免阻塞，超时即判定需要人工介入。

    返回 (success: bool, message: str)
    """
    if not DWS_CORE:
        return False, "DWS 未初始化"

    try:
        result = subprocess.run(
            [DWS_CORE, "auth", "login"],
            capture_output=True, timeout=AUTH_LOGIN_TIMEOUT
        )
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
        stderr = result.stderr.decode("utf-8", errors="replace").strip()

        if result.returncode == 0:
            # 成功刷新
            return True, "token 已自动刷新"

        # 非零退出码，解析错误
        err_msg = stderr or stdout or f"exit code {result.returncode}"
        try:
            err_data = json.loads(stderr or stdout)
            err_msg = err_data.get("error", err_data.get("message", err_msg))
            if isinstance(err_msg, dict):
                err_msg = err_msg.get("message", str(err_msg))
        except (json.JSONDecodeError, TypeError):
            err_msg = err_msg[:200]

        return False, str(err_msg)

    except subprocess.TimeoutExpired:
        return False, f"超时 ({AUTH_LOGIN_TIMEOUT}s)，可能需要扫码登录"
    except Exception as e:
        return False, str(e)


def notify_auth_expired(status):
    """
    认证过期通知：写入状态文件 + Windows 桌面通知 + 日志记录。
    """
    # 1. 写入 auth_state.json
    alert = {
        "alert_time": datetime.now().isoformat(),
        "authenticated": status.get("authenticated"),
        "token_valid": status.get("token_valid"),
        "refresh_token_valid": status.get("refresh_token_valid"),
        "expires_at": status.get("expires_at"),
        "refresh_expires_at": status.get("refresh_expires_at"),
        "hours_left": status.get("hours_left"),
        "refresh_hours_left": status.get("refresh_hours_left"),
        "action_needed": "请打开 QoderWork 重新登录钉钉，或在终端运行: dws auth login",
    }
    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        with open(AUTH_STATE_FILE, "w", encoding="utf-8") as f:
            json.dump(alert, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

    # 2. Windows 桌面通知 (toast)
    if sys.platform == "win32":
        title = "钉钉同步 - 认证已过期"
        hours_left = status.get("hours_left")
        refresh_hours = status.get("refresh_hours_left")

        if hours_left is not None and hours_left > 0:
            msg = f"Token 将在 {hours_left:.1f} 小时后过期，请尽快重新登录"
        elif refresh_hours is not None and refresh_hours <= 0:
            msg = "Refresh Token 已过期，请打开 QoderWork 或在终端运行 dws auth login 重新扫码登录"
        else:
            msg = "认证已失效，请打开 QoderWork 或在终端运行 dws auth login 重新扫码登录"

        try:
            ps_cmd = (
                f'[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null; '
                f'$n = New-Object System.Windows.Forms.NotifyIcon; '
                f'$n.Icon = [System.Drawing.SystemIcons]::Warning; '
                f'$n.Visible = $true; '
                f'$n.ShowBalloonTip(10000, "{title}", "{msg}", '
                f'[System.Windows.Forms.ToolTipIcon]::Warning); '
                f'Start-Sleep -Seconds 12; $n.Dispose()'
            )
            subprocess.Popen(
                ["powershell", "-NoProfile", "-Command", ps_cmd],
                creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
            )
        except Exception:
            pass

    # 3. 同时尝试写 Windows 事件日志（计划任务场景下更可靠）
    try:
        evt_msg = (
            f"钉钉同步认证过期警告\n"
            f"token_valid: {status.get('token_valid')}\n"
            f"refresh_token_valid: {status.get('refresh_token_valid')}\n"
            f"expires_at: {status.get('expires_at')}\n"
            f"操作: 请运行 dws auth login 或在 QoderWork 中重新登录"
        )
        subprocess.run(
            ["powershell", "-NoProfile", "-Command",
             f'Write-EventLog -LogName Application -Source "Application" '
             f'-EventId 9001 -EntryType Warning -Message "{evt_msg}"'],
            capture_output=True, timeout=5,
            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
        )
    except Exception:
        pass


def save_auth_state(status):
    """保存当前认证状态到 auth_state.json（正常情况下的快照）"""
    state = {
        "last_check": datetime.now().isoformat(),
        "authenticated": status.get("authenticated"),
        "token_valid": status.get("token_valid"),
        "refresh_token_valid": status.get("refresh_token_valid"),
        "expires_at": status.get("expires_at"),
        "refresh_expires_at": status.get("refresh_expires_at"),
        "hours_left": status.get("hours_left"),
        "refresh_hours_left": status.get("refresh_hours_left"),
        "status": "ok",
    }
    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        with open(AUTH_STATE_FILE, "w", encoding="utf-8") as f:
            json.dump(state, f, ensure_ascii=False, indent=2)
    except Exception:
        pass


def ensure_auth():
    """
    认证保障入口。在同步开始前调用。

    策略:
      1. 检查认证状态
      2. token 有效且 > 48h → 正常继续
      3. token 有效但 < 48h → 尝试静默刷新，继续（无论刷新是否成功）
      4. token 过期但 refresh 有效 → 尝试静默刷新，成功则继续
      5. refresh 也过期 → 通知用户，中止同步

    返回 (ok: bool, message: str)
    """
    log("检查认证状态...")

    status = check_auth_status()

    if status.get("error"):
        log(f"认证状态检查失败: {status['error']}", "WARN")
        # 无法确认状态时，乐观继续
        log("无法确认认证状态，尝试继续运行...", "WARN")
        return True, "认证状态未知，乐观继续"

    authenticated = status.get("authenticated", False)
    token_valid = status.get("token_valid", False)
    refresh_valid = status.get("refresh_token_valid", False)
    hours_left = status.get("hours_left")
    refresh_hours = status.get("refresh_hours_left")

    # 显示状态摘要
    token_info = ""
    if hours_left is not None:
        if hours_left > 24:
            token_info = f"token 剩余 {hours_left:.0f}h"
        else:
            token_info = f"token 剩余 {hours_left:.1f}h"
    if refresh_hours is not None:
        if refresh_hours > 24:
            token_info += f", refresh 剩余 {refresh_hours:.0f}h"
        else:
            token_info += f", refresh 剩余 {refresh_hours:.1f}h"
    if token_info:
        log(f"  {token_info}")

    # 情况 5: 完全未认证
    if not authenticated:
        log("认证已失效 (authenticated=false)", "ERROR")
        notify_auth_expired(status)
        return False, "认证已失效，需要重新登录"

    # 情况 4: token 过期但 refresh 有效
    if not token_valid and refresh_valid:
        log("Access token 已过期，尝试自动刷新...")
        ok, msg = try_auth_refresh()
        if ok:
            log(f"  自动刷新成功: {msg}")
            # 验证刷新结果
            new_status = check_auth_status()
            save_auth_state(new_status)
            return True, "token 已自动刷新"
        else:
            log(f"  自动刷新失败: {msg}", "ERROR")
            notify_auth_expired(status)
            return False, f"自动刷新失败: {msg}"

    # 情况 4b: token 和 refresh 都过期
    if not token_valid and not refresh_valid:
        log("Token 和 Refresh Token 均已过期", "ERROR")
        notify_auth_expired(status)
        return False, "Token 和 Refresh Token 均已过期，需要重新扫码登录"

    # 情况 2 & 3: token 有效
    save_auth_state(status)

    if hours_left is not None and hours_left < AUTH_WARN_HOURS:
        # 即将过期，尝试提前刷新
        log(f"Token 将在 {hours_left:.1f}h 后过期，尝试提前刷新...")
        ok, msg = try_auth_refresh()
        if ok:
            log(f"  提前刷新成功: {msg}")
            new_status = check_auth_status()
            save_auth_state(new_status)
        else:
            # 提前刷新失败不阻塞，但记录警告
            log(f"  提前刷新失败（不影响本次同步）: {msg}", "WARN")
            if refresh_hours is not None and refresh_hours < AUTH_WARN_HOURS:
                notify_auth_expired(status)
        return True, f"token 即将过期 ({hours_left:.1f}h)，本次同步正常继续"

    return True, "认证正常"


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


def find_dws_core(config_path=""):
    """
    自动检测 dws-core 可执行文件路径。
    config_path: 配置文件中指定的路径（优先使用）。
    """
    global DWS_CORE

    # 优先级: 配置文件 > 环境变量 > QoderWork bin > 系统 PATH
    candidates = []

    # 0. 配置文件指定
    if config_path:
        cp = Path(config_path)
        if cp.is_absolute():
            candidates.append(cp)
        else:
            candidates.append((TOOLS_DIR / cp).resolve())

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
    log("请确保已安装 QoderWork，或在 config.json 的 paths.dws_core 中指定路径", "ERROR")
    log("也可以设置 DWS_CORE_PATH 环境变量", "ERROR")
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


def extract_image_messages(messages):
    """
    从消息列表中提取图片消息。
    返回 [{mediaId, openMessageId, createTime, senderName, convId, convTitle}, ...]
    支持两种格式:
      - [图片消息](mediaId=XXX) 带 mediaId 的富文本图片
      - [图片] 简单图片标记（无 mediaId，仅记录）
    """
    images = []
    for msg in messages:
        if not isinstance(msg, dict):
            continue
        content = msg.get("content", "")

        # 提取带 mediaId 的图片消息
        matches = IMAGE_MSG_RE.findall(content)
        if matches:
            sender = msg.get("sender", "")
            if isinstance(sender, dict):
                sender = sender.get("name", "")
            for media_id in matches:
                media_id = media_id.strip()
                # 统一为 @ 前缀格式（$前缀为旧格式）
                if media_id.startswith("$"):
                    media_id = "@" + media_id[1:]
                images.append({
                    "mediaId": media_id,
                    "openMessageId": msg.get("openMessageId", ""),
                    "createTime": msg.get("createTime", ""),
                    "senderName": msg.get("senderName", sender),
                })
        elif IMAGE_SIMPLE_RE.search(content) and not matches:
            # 简单 [图片] 标记，无 mediaId
            sender = msg.get("sender", "")
            if isinstance(sender, dict):
                sender = sender.get("name", "")
            images.append({
                "mediaId": "",
                "openMessageId": msg.get("openMessageId", ""),
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
                "_noMediaId": True,
            })
    return images


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


def load_image_manifest():
    """加载图片下载清单，返回 {mediaId: record} 字典"""
    records = load_json(IMAGE_MANIFEST_FILE, [])
    return {r["mediaId"]: r for r in records if "mediaId" in r and r["mediaId"]}


def save_image_manifest(manifest_dict):
    """保存图片下载清单"""
    records = list(manifest_dict.values())
    save_json(IMAGE_MANIFEST_FILE, records)


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


def get_image_download_url(media_id, conv_id, msg_id):
    """
    通过 dws mcp chat get_resource_download_url 获取图片下载链接。
    返回 (downloadUrl, filename, errorMsg) 三元组。
    成功时 errorMsg 为空字符串，失败时 downloadUrl 和 filename 为 None。
    """
    if not DWS_CORE:
        return None, None, "DWS 未初始化"

    # 使用 --json 参数传递，避免 @ 前缀被 CLI 解释为文件引用
    payload = json.dumps({
        "openConversationId": conv_id,
        "openMessageId": msg_id,
        "resourceId": media_id,
        "resourceType": "image",
    })

    try:
        result = subprocess.run(
            [DWS_CORE, "mcp", "chat", "get_resource_download_url",
             "--json", payload],
            capture_output=True, timeout=30
        )
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
        stderr = result.stderr.decode("utf-8", errors="replace").strip()
        if stdout and result.returncode == 0:
            data = json.loads(stdout)
            url = data.get("result", {}).get("downloadUrl", "")
            fname = data.get("result", {}).get("fileName", "")
            if url:
                return url, fname, ""
            return None, None, "API 返回空 downloadUrl"
        # 解析错误信息
        err_msg = ""
        for raw in (stderr, stdout):
            if raw:
                try:
                    err_data = json.loads(raw)
                    err_obj = err_data.get("error", err_data)
                    err_msg = err_obj.get("message", "")
                    err_code = err_obj.get("server_error_code", err_obj.get("code", ""))
                    if err_msg:
                        return None, None, f"[{err_code}] {err_msg}" if err_code else err_msg
                except json.JSONDecodeError:
                    err_msg = raw[:300]
        return None, None, err_msg or f"exit code {result.returncode}"
    except subprocess.TimeoutExpired:
        return None, None, "命令超时 (30s)"
    except json.JSONDecodeError as e:
        return None, None, f"JSON 解析失败: {e}"
    except Exception as e:
        return None, None, str(e)


def download_image_native_api(access_token, media_id, dest_path):
    """
    通过钉钉原生 media download API 下载图片。
    这是 get_resource_download_url 不支持 image 时的 fallback。
    返回 (success: bool, error_msg: str)
    """
    if not access_token:
        return False, "未配置 access_token"

    url = f"https://oapi.dingtalk.com/media/download?access_token={access_token}&media_id={media_id}"

    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", "DingTalkSync/1.0")

        with urllib.request.urlopen(req, timeout=60) as response:
            content_type = response.headers.get("Content-Type", "")

            # 如果返回 JSON，说明是错误信息
            if "json" in content_type or "text/plain" in content_type:
                body = response.read().decode("utf-8", errors="replace")
                try:
                    err_data = json.loads(body)
                    err_msg = err_data.get("errmsg", err_data.get("message", body[:200]))
                    return False, f"API error: {err_msg}"
                except json.JSONDecodeError:
                    return False, f"Unexpected response: {body[:200]}"

            # 二进制内容 = 图片数据
            dest_path = Path(dest_path)
            dest_path.parent.mkdir(parents=True, exist_ok=True)

            # 根据 Content-Type 推断扩展名
            ext_map = {
                "image/jpeg": ".jpg",
                "image/png": ".png",
                "image/gif": ".gif",
                "image/webp": ".webp",
                "image/bmp": ".bmp",
            }
            for ct, ext in ext_map.items():
                if ct in content_type:
                    # 更新文件扩展名
                    if dest_path.suffix != ext:
                        dest_path = dest_path.with_suffix(ext)
                    break

            tmp_path = dest_path.with_suffix(dest_path.suffix + ".tmp")
            with open(tmp_path, "wb") as f:
                while True:
                    chunk = response.read(8192)
                    if not chunk:
                        break
                    f.write(chunk)
            tmp_path.rename(dest_path)
            return True, ""

    except urllib.error.HTTPError as e:
        body = ""
        if e.fp:
            body = e.read().decode("utf-8", errors="replace")[:300]
        return False, f"HTTP {e.code}: {body}"

    except urllib.error.URLError as e:
        return False, f"URL Error: {e.reason}"

    except Exception as e:
        return False, str(e)


# ============================================================
# 核心同步逻辑
# ============================================================

def scan_conversation(conv_id, conv_title, start_time, space_ids_cache):
    """
    扫描单个会话的所有消息，返回 (files_found, images_found) 元组。
    同时更新 space_ids_cache。
    """
    files_found = []
    images_found = []
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

        # 提取图片消息
        img_msgs = extract_image_messages(messages)
        for im in img_msgs:
            im["convId"] = conv_id
            im["convTitle"] = conv_title
        images_found.extend(img_msgs)

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

    return files_found, images_found


def retry_failed_images(dingtalk_token):
    """
    重试之前因 unsupported resourceType 而失败的图片。
    使用钉钉原生 media download API。
    返回 (retried_count, success_count) 元组。
    """
    if not dingtalk_token:
        log("未配置 access_token，无法重试图片", "WARN")
        log("请使用 --dingtalk-token 参数或在 config.json 的 dingtalk.access_token 配置")
        return 0, 0

    image_manifest = load_image_manifest()
    # 筛选需要重试的记录：_pending 且有 _error 包含 unsupported 或无 _error
    retry_candidates = []
    for mid, record in image_manifest.items():
        if not record.get("_pending"):
            continue
        err = record.get("_error", "")
        # 重试：unsupported resourceType 或无错误信息的旧记录
        if "unsupported" in err or not err:
            if record.get("mediaId"):  # 必须有 mediaId
                retry_candidates.append(record)

    if not retry_candidates:
        log("没有需要重试的图片")
        return 0, 0

    log("=" * 50)
    log(f"重试失败的图片 ({len(retry_candidates)} 个)")
    log("=" * 50)

    IMAGE_DIR.mkdir(parents=True, exist_ok=True)
    retried = 0
    success = 0

    for i, record in enumerate(retry_candidates):
        mid = record["mediaId"]
        conv_title = record.get("convTitle", "unknown")
        sender = record.get("sender", "")
        create_time = record.get("createTime", "")
        msg_id = record.get("openMessageId", "")
        progress = f"[{i+1}/{len(retry_candidates)}]"

        date_str = create_time[:10] if create_time else "unknown"
        safe_title = safe_dirname(conv_title)
        img_dir = IMAGE_DIR / safe_title / date_str

        mid_hash = hashlib.md5(mid.encode()).hexdigest()[:12]
        img_filename = f"{mid_hash}.jpg"
        img_path = img_dir / img_filename

        # 已存在则跳过
        if img_path.exists():
            success += 1
            record["_downloaded"] = True
            record.pop("_pending", None)
            record.pop("_error", None)
            record["_localPath"] = str(img_path)
            image_manifest[mid] = record
            continue

        time.sleep(REQUEST_INTERVAL)
        ok, fb_err = download_image_native_api(dingtalk_token, mid, img_path)

        if ok:
            success += 1
            file_size = img_path.stat().st_size
            size_str = format_size(file_size)
            actual_name = img_path.name
            log(f"  {progress} 重试成功: {safe_title}/{actual_name} ({size_str})")
            record["_downloaded"] = True
            record["_downloadMethod"] = "native_api_retry"
            record.pop("_pending", None)
            record.pop("_error", None)
            record["_localPath"] = str(img_path)
            image_manifest[mid] = record
        else:
            record["_error"] = f"原生API重试失败: {fb_err}"
            image_manifest[mid] = record
            log(f"  {progress} 重试失败: {conv_title} ({sender}) - {fb_err}")

        retried += 1

        # 每 20 个保存一次
        if (i + 1) % 20 == 0:
            save_image_manifest(image_manifest)

    save_image_manifest(image_manifest)
    log(f"图片重试完成: 尝试{retried}, 成功{success}")
    write_log(f"图片重试完成: 尝试{retried}, 成功{success}")
    return retried, success


def run_sync(args):
    """执行同步"""

    ensure_dirs()

    # 解析钉钉 access_token（用于图片下载 fallback）
    # 优先级: 命令行参数 > config.json > 空
    dingtalk_token = getattr(args, 'dingtalk_token', '') or ''
    if not dingtalk_token:
        # 尝试从 config 读取（config 已在 main 中通过 apply_config 加载）
        config = load_config()
        if config:
            dt_conf = config.get("dingtalk", {})
            dingtalk_token = dt_conf.get("access_token", "")
    if dingtalk_token:
        log(f"钉钉 access_token 已配置（用于图片下载 fallback）")

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

    # 加载图片清单
    image_manifest = load_image_manifest()
    log(f"图片清单: {len(image_manifest)} 个图片")

    # 加载 spaceId 缓存
    space_ids = load_space_ids()

    # ========== 阶段 1: 扫描 ==========
    log("=" * 50)
    log("阶段 1: 扫描会话消息")
    log("=" * 50)

    new_files = []
    new_images = []
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
            files, images = scan_conversation(conv_id, conv_title, start_time, space_ids)
            if files:
                log(f"  [{conv_title}] 发现 {len(files)} 个文件", "INFO")
            if images:
                log(f"  [{conv_title}] 发现 {len(images)} 个图片", "INFO")

            # 过滤已下载的文件
            for f in files:
                fid = f["fileId"]
                if fid not in manifest:
                    # 补充 spaceId
                    if conv_id in space_ids:
                        f["spaceId"] = space_ids[conv_id]
                    new_files.append(f)

            # 过滤已下载的图片
            for img in images:
                mid = img["mediaId"]
                if mid and mid not in image_manifest:
                    new_images.append(img)
                elif not mid and img.get("_noMediaId"):
                    # 无 mediaId 的图片用 openMessageId 去重
                    omid = img.get("openMessageId", "")
                    if omid and omid not in image_manifest:
                        new_images.append(img)

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

    # 按 mediaId 去重图片
    seen_img_ids = set(image_manifest.keys())
    unique_new_images = []
    for img in new_images:
        mid = img["mediaId"] or img.get("openMessageId", "")
        if mid and mid not in seen_img_ids:
            seen_img_ids.add(mid)
            unique_new_images.append(img)

    log(f"扫描完成: {scanned} 个会话, 发现 {len(unique_new)} 个新文件, {len(unique_new_images)} 个新图片, {errors} 个错误")

    if not unique_new and not unique_new_images:
        log("没有新文件/图片需要同步")
        # 保存 spaceId 缓存
        save_space_ids(space_ids)
        write_log(f"扫描完成: 无新文件/图片 (扫描 {scanned} 个会话)")
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

    # ========== 阶段 3: 同步图片 ==========
    img_downloaded = 0
    img_failed = 0
    img_no_media = 0

    if unique_new_images:
        log("=" * 50)
        log(f"阶段 3: 同步图片 ({len(unique_new_images)} 个)")
        log("=" * 50)

        IMAGE_DIR.mkdir(parents=True, exist_ok=True)

        for i, img in enumerate(unique_new_images):
            mid = img["mediaId"]
            conv_title = img.get("convTitle", "unknown")
            sender = img.get("senderName", "")
            create_time = img.get("createTime", "")
            msg_id = img.get("openMessageId", "")
            progress = f"[{i+1}/{len(unique_new_images)}]"

            # 无 mediaId 的图片只记录
            if not mid or img.get("_noMediaId"):
                img_no_media += 1
                log(f"  {progress} 无mediaId，仅记录: {conv_title} ({sender})")
                # 用 openMessageId 作为 key
                record_key = mid or msg_id
                image_manifest[record_key] = {
                    "mediaId": mid,
                    "openMessageId": msg_id,
                    "createTime": create_time,
                    "sender": sender,
                    "convId": img.get("convId", ""),
                    "convTitle": conv_title,
                    "_noMediaId": True,
                }
                continue

            # 检查本地是否已存在
            date_str = create_time[:10] if create_time else "unknown"
            safe_title = safe_dirname(conv_title)
            img_dir = IMAGE_DIR / safe_title / date_str

            # 生成文件名: 基于 mediaId hash
            mid_hash = hashlib.md5(mid.encode()).hexdigest()[:12]
            img_filename = f"{mid_hash}.jpg"
            img_path = img_dir / img_filename

            if img_path.exists():
                img_downloaded += 1
                log(f"  {progress} 已存在: {safe_title}/{img_filename}")
                record_key = mid
                image_manifest[record_key] = {
                    "mediaId": mid,
                    "openMessageId": msg_id,
                    "createTime": create_time,
                    "sender": sender,
                    "convId": img.get("convId", ""),
                    "convTitle": conv_title,
                    "_downloaded": True,
                    "_localPath": str(img_path),
                }
                continue

            # 尝试获取下载链接
            time.sleep(REQUEST_INTERVAL)
            url, dl_filename, err_msg = get_image_download_url(mid, img.get("convId", ""), msg_id)

            if url:
                # 如果有文件名，使用原始扩展名
                if dl_filename:
                    ext = os.path.splitext(dl_filename)[1] or ".jpg"
                    img_filename = f"{mid_hash}{ext}"
                    img_path = img_dir / img_filename

                log(f"  {progress} 下载中: {conv_title}/{img_filename}...")
                ok = download_file(url, img_path)
                if ok:
                    img_downloaded += 1
                    file_size = img_path.stat().st_size
                    size_str = format_size(file_size)
                    log(f"  {progress} 完成: {img_filename} ({size_str})")
                    image_manifest[mid] = {
                        "mediaId": mid,
                        "openMessageId": msg_id,
                        "createTime": create_time,
                        "sender": sender,
                        "convId": img.get("convId", ""),
                        "convTitle": conv_title,
                        "_downloaded": True,
                        "_localPath": str(img_path),
                    }
                else:
                    img_failed += 1
                    log(f"  {progress} 下载失败: {conv_title}/{img_filename} (文件写入或网络错误)")
                    image_manifest[mid] = {
                        "mediaId": mid,
                        "openMessageId": msg_id,
                        "createTime": create_time,
                        "sender": sender,
                        "convId": img.get("convId", ""),
                        "convTitle": conv_title,
                        "_failed": True,
                        "_error": "download_file 失败",
                    }
            else:
                # MCP API 获取下载链接失败
                err_detail = err_msg or "未知原因"

                # 检查是否可以使用原生 API fallback
                is_unsupported = "unsupported resourceType" in err_detail
                fallback_ok = False

                if is_unsupported and dingtalk_token:
                    # Fallback: 使用钉钉原生 media download API
                    log(f"  {progress} MCP 不支持图片类型，尝试原生 API fallback: {conv_title} ({sender})")
                    time.sleep(REQUEST_INTERVAL)
                    fb_ok, fb_err = download_image_native_api(dingtalk_token, mid, img_path)
                    if fb_ok:
                        fallback_ok = True
                        img_downloaded += 1
                        file_size = img_path.stat().st_size
                        size_str = format_size(file_size)
                        # 检查实际保存的文件扩展名
                        actual_name = img_path.name
                        log(f"  {progress} 完成(native): {safe_title}/{actual_name} ({size_str})")
                        image_manifest[mid] = {
                            "mediaId": mid,
                            "openMessageId": msg_id,
                            "createTime": create_time,
                            "sender": sender,
                            "convId": img.get("convId", ""),
                            "convTitle": conv_title,
                            "_downloaded": True,
                            "_downloadMethod": "native_api",
                            "_localPath": str(img_path),
                        }
                    else:
                        err_detail = f"MCP失败({err_detail}) + 原生API失败({fb_err})"
                        log(f"  {progress} 原生 API 也失败: {fb_err}")
                elif is_unsupported and not dingtalk_token:
                    err_detail = err_detail + " (提示: 配置 --dingtalk-token 可启用原生 API fallback)"

                if not fallback_ok:
                    img_failed += 1
                    log(f"  {progress} 无法下载: {conv_title} ({sender}) - {err_detail}")
                    image_manifest[mid] = {
                        "mediaId": mid,
                        "openMessageId": msg_id,
                        "createTime": create_time,
                        "sender": sender,
                        "convId": img.get("convId", ""),
                        "convTitle": conv_title,
                        "_pending": True,
                        "_error": err_detail,
                    }

            # 每 20 个图片保存一次清单
            if (i + 1) % 20 == 0:
                save_image_manifest(image_manifest)

        # 保存图片清单
        save_image_manifest(image_manifest)
        log(f"图片同步完成: 下载{img_downloaded}, 失败{img_failed}, 无mediaId{img_no_media}")
    elif unique_new:
        # 没有新图片但有新文件时，也保存图片清单
        save_image_manifest(image_manifest)

    # ========== 结果汇总 ==========
    log("=" * 50)
    log("同步完成!")
    log(f"  新发现文件: {len(unique_new)} 个")
    log(f"  文件已下载: {downloaded}")
    log(f"  文件已过期: {expired}")
    log(f"  文件失败:   {failed}")
    log(f"  文件清单:   {len(manifest)} 个")
    if unique_new_images:
        log(f"  新发现图片: {len(unique_new_images)} 个")
        log(f"  图片已下载: {img_downloaded}")
        log(f"  图片失败:   {img_failed}")
        log(f"  图片无mediaId: {img_no_media}")
        log(f"  图片清单:   {len(image_manifest)} 个")
    log("=" * 50)

    img_log = ""
    if unique_new_images:
        img_log = (f", 图片: 新{len(unique_new_images)}, "
                   f"下载{img_downloaded}, 失败{img_failed}, 无mediaId{img_no_media}")
    write_log(
        f"同步完成: 文件新{len(unique_new)}, 下载{downloaded}, "
        f"过期{expired}, 失败{failed}, 清单{len(manifest)}{img_log}"
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
    image_manifest = load_image_manifest()
    convs = load_json(CONVS_FILE)

    total = len(manifest)
    downloaded = sum(1 for r in manifest.values() if r.get("_downloaded"))
    expired = sum(1 for r in manifest.values() if r.get("_expired"))
    failed = sum(1 for r in manifest.values() if r.get("_failed"))
    pending = total - downloaded - expired - failed

    # 图片统计
    img_total = len(image_manifest)
    img_downloaded = sum(1 for r in image_manifest.values() if r.get("_downloaded"))
    img_pending = sum(1 for r in image_manifest.values() if r.get("_pending"))
    img_no_media = sum(1 for r in image_manifest.values() if r.get("_noMediaId"))

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
    print(f"  图片清单:   {img_total}")
    print(f"  图片已下载: {img_downloaded}")
    print(f"  图片待处理: {img_pending}")
    print(f"  图片无mediaId: {img_no_media}")
    print(f"  磁盘文件:   {disk_files} ({format_size(disk_size)})")
    print(f"  同步目录:   {SYNC_DIR}")

    # 认证状态
    if DWS_CORE:
        auth = check_auth_status()
        if not auth.get("error"):
            token_str = "有效" if auth["token_valid"] else "已过期"
            refresh_str = "有效" if auth["refresh_token_valid"] else "已过期"
            if auth.get("hours_left") is not None:
                token_str += f" ({auth['hours_left']:.1f}h)"
            if auth.get("refresh_hours_left") is not None:
                refresh_str += f" ({auth['refresh_hours_left']:.0f}h)"
            print(f"  认证 Token:  {token_str}")
            print(f"  认证 Refresh: {refresh_str}")
        else:
            print(f"  认证状态:   检查失败 ({auth['error']})")

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
  python dws_sync.py --init           首次运行，生成配置文件
  python dws_sync.py                  增量同步文件（最近7天）
  python dws_sync.py --full           全量扫描文件
  python dws_sync.py --days 30        扫描最近30天
  python dws_sync.py --scan-only      仅扫描文件，不下载
  python dws_sync.py --dry-run        预览将要下载的文件
  python dws_sync.py --export-csv     导出聊天记录到 CSV
  python dws_sync.py --all            同步文件 + 导出聊天记录
  python dws_sync.py --status         查看同步状态
  python dws_sync.py --config xx.json 使用指定配置文件
        """
    )

    parser.add_argument("--init", action="store_true", help="生成配置文件模板（首次运行）")
    parser.add_argument("--config", type=str, default="", help="指定配置文件路径（默认: 同目录 config.json）")
    parser.add_argument("--full", action="store_true", help="全量扫描（从2020年开始）")
    parser.add_argument("--days", type=int, default=None, help="增量扫描天数（默认读配置，否则7天）")
    parser.add_argument("--scan-only", action="store_true", help="仅扫描文件，不下载")
    parser.add_argument("--dry-run", action="store_true", help="预览模式，不实际下载")
    parser.add_argument("--export-csv", action="store_true", help="导出聊天记录到 CSV")
    parser.add_argument("--all", action="store_true", help="同时执行文件同步和聊天记录导出")
    parser.add_argument("--status", action="store_true", help="显示同步状态")
    parser.add_argument("--check-auth", action="store_true", help="仅检查认证状态，不执行同步")
    parser.add_argument("--dingtalk-token", type=str, default="",
                        help="钉钉 access_token（用于图片下载 fallback，也可在 config.json 的 dingtalk.access_token 配置）")
    parser.add_argument("--retry-images", action="store_true",
                        help="重试之前失败的图片下载（配合 --dingtalk-token 使用）")

    args = parser.parse_args()

    # ---- 初始化配置 ----
    if args.init:
        ok = init_config()
        return 0 if ok else 1

    # ---- 加载配置 ----
    config = None
    config_path_arg = args.config
    if config_path_arg:
        # 用户指定了配置文件
        cp = Path(config_path_arg)
        if not cp.is_absolute():
            cp = Path.cwd() / cp
        if not cp.exists():
            print(f"[ERROR] 配置文件不存在: {cp}", file=sys.stderr)
            return 1
        # 覆盖全局 CONFIG_FILE
        global CONFIG_FILE
        CONFIG_FILE = cp
        config = load_config()
    else:
        config = load_config()

    if config is None:
        # 没有配置文件，使用默认值，但提示用户
        print(f"提示: 未找到配置文件 {CONFIG_FILE}")
        print("运行 python dws_sync.py --init 生成配置文件")
        print("将使用默认配置继续运行...")
        print()

    # 应用配置
    if config:
        ok, err = apply_config(config)
        if not ok:
            print(f"[ERROR] 配置加载失败: {err}", file=sys.stderr)
            return 1

    # ---- 查找 DWS ----
    dws_config_path = ""
    if config:
        dws_config_path = config.get("paths", {}).get("dws_core", "")

    if not find_dws_core(dws_config_path):
        return 1

    # ---- 运行时自动补全账号信息 ----
    acct_name = ""
    acct_desc = ""
    if config:
        acct = config.get("account", {})
        acct_name = acct.get("name", "")
        acct_desc = acct.get("description", "")

    if not acct_name:
        info = detect_account_info()
        acct_name = info["name"]
        acct_desc = info["description"] or info["org_name"]
        if acct_name:
            log(f"自动检测到账号: {acct_name} ({acct_desc})")
            # 写回配置文件，下次就不用再探测了
            if config and CONFIG_FILE.exists():
                try:
                    config.setdefault("account", {})
                    config["account"]["name"] = acct_name
                    config["account"]["description"] = acct_desc
                    if info["corp_id"]:
                        config["account"]["corp_id"] = info["corp_id"]
                    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
                        json.dump(config, f, ensure_ascii=False, indent=2)
                    log(f"已自动写入 config.json")
                except Exception as e:
                    log(f"写入配置文件失败: {e}", "WARN")

    if acct_name:
        log(f"账号: {acct_name} ({acct_desc})")

    if args.status:
        show_status(args)
        return 0

    if args.check_auth:
        print("检查认证状态...\n")
        status = check_auth_status()
        if status.get("error"):
            print(f"[ERROR] {status['error']}")
            return 1
        print(f"  已认证:     {status['authenticated']}")
        print(f"  Token 有效:  {status['token_valid']}")
        print(f"  Refresh 有效: {status['refresh_token_valid']}")
        if status.get("hours_left") is not None:
            h = status["hours_left"]
            print(f"  Token 剩余:  {h:.1f} 小时 ({status['expires_at']})")
        if status.get("refresh_hours_left") is not None:
            h = status["refresh_hours_left"]
            print(f"  Refresh 剩余: {h:.1f} 小时 ({status['refresh_expires_at']})")
        # 尝试刷新
        if not status["token_valid"] and status["refresh_token_valid"]:
            print("\nToken 已过期，尝试自动刷新...")
            ok, msg = try_auth_refresh()
            print(f"  {'成功' if ok else '失败'}: {msg}")
        return 0

    log("钉钉同步工具 v1.4")
    log(f"工作目录: {SYNC_DIR}")

    # ---- 认证检查 ----
    auth_ok, auth_msg = ensure_auth()
    if not auth_ok:
        log(f"认证检查未通过，同步中止: {auth_msg}", "ERROR")
        write_log(f"认证检查未通过，同步中止: {auth_msg}")
        return 2
    if auth_msg != "认证正常":
        log(f"认证: {auth_msg}")

    # 从配置读取默认天数（如果命令行未指定）
    if args.days is None:
        if config:
            args.days = config.get("defaults", {}).get("days", 7)
        else:
            args.days = 7

    # 从配置读取 features 默认值
    if config:
        features = config.get("features", {})
        # 如果配置中 export_csv 为 true 且命令行未明确指定，自动开启
        if features.get("export_csv") and not args.export_csv and not args.all:
            args.all = True

    ret = 0

    # 解析 dingtalk_token（retry 模式需要）
    dingtalk_token = getattr(args, 'dingtalk_token', '') or ''
    if not dingtalk_token:
        config = load_config()
        if config:
            dingtalk_token = config.get("dingtalk", {}).get("access_token", "")

    # 文件同步
    if not args.export_csv or args.all:
        write_log(f"开始文件同步 (full={args.full}, days={args.days})")
        ret = run_sync(args)

    # 重试失败的图片
    if args.retry_images and dingtalk_token:
        retried, retry_success = retry_failed_images(dingtalk_token)
    elif args.retry_images and not dingtalk_token:
        log("--retry-images 需要配合 --dingtalk-token 或 config.json 的 dingtalk.access_token", "ERROR")

    # 聊天记录导出
    if args.export_csv or args.all:
        ret2 = run_export_csv(args)
        if ret2 != 0:
            ret = ret2

    return ret


if __name__ == "__main__":
    sys.exit(main())
