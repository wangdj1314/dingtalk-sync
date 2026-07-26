#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
钉钉同步工具 - DingTalk Sync (Standalone)
==========================================
独立运行的钉钉同步工具。扫描会话中的文件消息和图片消息并下载到本地，
同时支持导出聊天记录为 CSV。

不依赖 QoderWork 运行环境，仅需 dws-core 二进制文件（QoderWork 安装时自带）。

用法:
    python dingtalk_sync.py              增量同步（最近7天）
    python dingtalk_sync.py --all        文件同步 + 聊天记录导出
    python dingtalk_sync.py --full       全量扫描
    python dingtalk_sync.py --days 30    扫描最近30天
    python dingtalk_sync.py --status     查看同步状态
    python dingtalk_sync.py --estimate   估算数据量和磁盘空间
    python dingtalk_sync.py --setup-task 安装 Windows 计划任务（每天自动运行）
    python dingtalk_sync.py --remove-task  卸载计划任务
    python dingtalk_sync.py --init       首次运行，生成配置文件

依赖:
    - Python 3.8+
    - dws-core CLI（QoderWork 安装时自动部署）

配置文件:
    脚本根目录的 sync_config.json，首次运行 --init 自动生成。

版本: 2.3
"""

import argparse
import csv
import hashlib
import json
import os
import platform
import re
import shutil
import subprocess
import sys
import threading
import time
import urllib.request
import urllib.error
from datetime import datetime, timedelta
from pathlib import Path

__version__ = "2.3"

# ============================================================
# 路径配置
# ============================================================

# 脚本所在目录 = 同步根目录（打包后为 exe 所在目录）
if getattr(sys, "frozen", False):
    BASE_DIR = Path(sys.executable).parent.resolve()
else:
    BASE_DIR = Path(__file__).parent.resolve()
STATE_DIR = BASE_DIR / "_sync_state"

# 数据文件
CONVS_FILE = BASE_DIR / "_all_convs.json"
MANIFEST_FILE = STATE_DIR / "download_manifest.json"
SPACE_IDS_FILE = STATE_DIR / "space_ids.json"
SYNC_LOG_FILE = STATE_DIR / "sync.log"
CHAT_EXPORT_DIR = BASE_DIR / "_chat_export"
CHAT_STATE_FILE = STATE_DIR / "chat_export_state.json"
IMAGE_MANIFEST_FILE = STATE_DIR / "image_manifest.json"
IMAGE_DIR = BASE_DIR / "_images"
AUTH_STATE_FILE = STATE_DIR / "auth_state.json"
AUTH_ALERT_FILE = STATE_DIR / "auth_alert.json"   # Qt 程序监听此文件弹出登录窗口

# 日程/待办/听记 导出目录
CALENDAR_EXPORT_DIR = BASE_DIR / "_calendar_export"
TODO_EXPORT_DIR = BASE_DIR / "_todo_export"
MINUTES_EXPORT_DIR = BASE_DIR / "_minutes_export"
CALENDAR_STATE_FILE = STATE_DIR / "calendar_state.json"
TODO_STATE_FILE = STATE_DIR / "todo_state.json"
MINUTES_STATE_FILE = STATE_DIR / "minutes_state.json"

# 通讯录导出目录
CONTACTS_EXPORT_DIR = BASE_DIR / "_contacts_export"
CONTACTS_STATE_FILE = STATE_DIR / "contacts_state.json"

# 认证参数
AUTH_WARN_HOURS = 48

# ============================================================
# 协作式取消机制（供 Qt 工作线程调用）
# ============================================================

_cancel_event = threading.Event()


def request_cancel():
    """请求取消当前同步操作"""
    _cancel_event.set()


def clear_cancel():
    """开始新同步前清除取消标志"""
    _cancel_event.clear()


def is_cancelled():
    """检查是否已请求取消"""
    return _cancel_event.is_set()
AUTH_LOGIN_TIMEOUT = 15

# DWS 可执行文件路径（运行时自动检测）
DWS_CORE = None

# Windows 下隐藏子进程控制台窗口（防止后台运行时弹出大量 CMD）
_CREATE_NO_WINDOW = 0x08000000 if platform.system() == "Windows" else 0

# 正则
FILE_MSG_RE = re.compile(r"\[文件\]\s*(.+?)\s+fileId:\s*(\S+)")
IMAGE_MSG_RE = re.compile(r"\[图片消息\]\(mediaId=([^\)]+)\)")
IMAGE_SIMPLE_RE = re.compile(r"\[图片\]")
VIDEO_MSG_RE = re.compile(r"\[视频消息\]\(mediaId=([^\)]+)\)")
VIDEO_SIMPLE_RE = re.compile(r"\[视频\]")
FOLDER_MSG_RE = re.compile(r"\[文件夹\]\s*(.+)")
# 从钉钉深度链接中提取 spaceId 和 fileId
DINGTALK_URL_RE = re.compile(
    r"dingtalk://[^\"'\s]*?spaceId=(\d+)[^\"'\s]*?fileId=(\d+)"
    r"|dingtalk://[^\"'\s]*?fileId=(\d+)[^\"'\s]*?spaceId=(\d+)"
)

# 请求间隔
REQUEST_INTERVAL = 0.3

# 配置文件
CONFIG_FILE = BASE_DIR / "sync_config.json"


# ============================================================
# 配置文件管理
# ============================================================

def load_config():
    """加载配置文件，不存在返回 None"""
    if not CONFIG_FILE.exists():
        return None
    try:
        with open(CONFIG_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, OSError) as e:
        print(f"[ERROR] 配置文件读取失败: {CONFIG_FILE} - {e}", file=sys.stderr)
        return None


def init_config():
    """生成配置文件模板，自动探测环境"""
    if CONFIG_FILE.exists():
        print(f"配置文件已存在: {CONFIG_FILE}")
        print("如需重置，请先删除后重新运行 --init")
        return False

    home = Path.home()
    system = platform.system()
    arch = platform.machine().lower()

    # 推测 dws-core 路径
    qoderwork_bin = home / ".qoderworkcn" / "bin" / "dws-ext"
    if system == "Windows":
        dws_name = "dws-core-windows-arm64.exe" if "arm64" in arch else "dws-core-windows-amd64.exe"
    elif system == "Darwin":
        dws_name = "dws-core-darwin-arm64" if "arm64" in arch else "dws-core-darwin-amd64"
    else:
        dws_name = "dws-core-linux-arm64" if "arm64" in arch else "dws-core-linux-amd64"

    guessed_dws = str(qoderwork_bin / dws_name)
    if not Path(guessed_dws).exists():
        guessed_dws = ""

    # 探测账号信息
    print("正在探测环境...")
    global DWS_CORE
    acct_name, acct_desc, corp_id = "", "", ""
    found_dws = find_dws_core(guessed_dws)
    if found_dws:
        info = detect_account_info()
        acct_name = info["name"]
        acct_desc = info["description"]
        corp_id = info["corp_id"]
        if acct_name:
            print(f"  已检测到: {acct_name} ({acct_desc})")
        else:
            print("  未能自动检测账号信息")
    else:
        print("  未找到 dws-core")

    config = {
        "version": 2,
        "account": {
            "name": acct_name,
            "description": acct_desc or "钉钉账号备注",
            "corp_id": corp_id
        },
        "paths": {
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
        },
        "dingtalk": {
            "access_token": ""
        },
        "task": {
            "run_time": "21:00",
            "run_days": 7
        }
    }

    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        json.dump(config, f, ensure_ascii=False, indent=2)

    print(f"\n配置文件已生成: {CONFIG_FILE}")
    needs_edit = []
    if not acct_name:
        needs_edit.append("  account.name -> 填写你的名字")
    if not guessed_dws:
        needs_edit.append("  paths.dws_core -> 填写 dws-core 路径")
    if needs_edit:
        print("请确认以下字段:")
        for line in needs_edit:
            print(line)
    else:
        print("所有字段已自动填写。")
    print(f"\n运行 python dingtalk_sync.py 开始同步")
    print(f"运行 python dingtalk_sync.py --setup-task 安装计划任务")
    return True


def apply_config(config):
    """将配置文件中的值应用到全局变量"""
    global CONVS_FILE, CHAT_EXPORT_DIR, REQUEST_INTERVAL

    if not config:
        return False, "配置为空"

    paths = config.get("paths", {})

    convs_str = paths.get("convs_file", "_all_convs.json")
    convs_path = Path(convs_str)
    CONVS_FILE = convs_path if convs_path.is_absolute() else BASE_DIR / convs_str

    export_subdir = paths.get("chat_export_subdir", "_chat_export")
    export_path = Path(export_subdir)
    CHAT_EXPORT_DIR = export_path if export_path.is_absolute() else BASE_DIR / export_subdir

    defaults = config.get("defaults", {})
    interval = defaults.get("request_interval", 0.3)
    if isinstance(interval, (int, float)) and interval >= 0:
        REQUEST_INTERVAL = interval

    return True, ""


def detect_account_info():
    """通过 dws-core 自动探测钉钉账号信息"""
    info = {"name": "", "description": "", "corp_id": "", "org_name": "", "dept_name": "", "user_id": ""}
    if not DWS_CORE:
        return info

    try:
        result = subprocess.run(
            [DWS_CORE, "contact", "user", "get-self"],
            capture_output=True, timeout=15,
            creationflags=_CREATE_NO_WINDOW
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
                parts = [p for p in [info["org_name"], info["dept_name"]] if p]
                info["description"] = " / ".join(parts)
    except Exception as e:
        log(f"自动探测账号信息失败: {e}", "WARN")

    if not info["corp_id"]:
        try:
            result = subprocess.run(
                [DWS_CORE, "auth", "status"],
                capture_output=True, timeout=10,
                creationflags=_CREATE_NO_WINDOW
            )
            stdout = result.stdout.decode("utf-8", errors="replace").strip()
            if stdout and result.returncode == 0:
                data = json.loads(stdout)
                info["corp_id"] = data.get("corp_id", "")
        except Exception:
            pass

    return info


# ============================================================
# 认证管理
# ============================================================

def check_auth_status():
    """检查 DWS 认证状态"""
    result_info = {
        "authenticated": False, "token_valid": False, "refresh_token_valid": False,
        "expires_at": None, "refresh_expires_at": None,
        "hours_left": None, "refresh_hours_left": None, "error": None,
    }
    if not DWS_CORE:
        result_info["error"] = "DWS 未初始化"
        return result_info

    try:
        result = subprocess.run(
            [DWS_CORE, "auth", "status"],
            capture_output=True, timeout=10,
            creationflags=_CREATE_NO_WINDOW
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

        now = datetime.now().astimezone()
        exp_str = result_info["expires_at"]
        if exp_str:
            try:
                exp_dt = datetime.fromisoformat(exp_str)
                result_info["hours_left"] = (exp_dt - now).total_seconds() / 3600
            except (ValueError, TypeError, OverflowError):
                pass

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
    """尝试通过 dws auth login 自动刷新 token"""
    if not DWS_CORE:
        return False, "DWS 未初始化"

    try:
        result = subprocess.run(
            [DWS_CORE, "auth", "login"],
            capture_output=True, timeout=AUTH_LOGIN_TIMEOUT,
            creationflags=_CREATE_NO_WINDOW
        )
        if result.returncode == 0:
            return True, "token 已自动刷新"

        stderr = result.stderr.decode("utf-8", errors="replace").strip()
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
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


def _build_auth_alert_msg(status):
    """根据认证状态生成通知标题和正文（通用，不绑定用户）"""
    hours_left = status.get("hours_left")
    refresh_hours = status.get("refresh_hours_left")
    token_valid = status.get("token_valid", False)
    refresh_valid = status.get("refresh_token_valid", False)

    if not token_valid and not refresh_valid:
        title = "钉钉同步 - 认证已完全失效"
        msg = "Token 和 Refresh Token 均已过期，同步已停止。请打开终端运行 dws auth login 重新扫码登录。"
        level = "critical"
    elif not token_valid and refresh_valid:
        title = "钉钉同步 - Token 已过期"
        msg = "Access Token 已过期且自动刷新失败。请打开终端运行 dws auth login 重新扫码登录。"
        level = "critical"
    elif hours_left is not None and hours_left > 0:
        title = "钉钉同步 - Token 即将过期"
        msg = f"Token 将在 {hours_left:.1f} 小时后过期。如自动刷新失败，请运行 dws auth login 重新登录。"
        level = "warning"
    else:
        title = "钉钉同步 - 认证异常"
        msg = "认证状态异常，同步可能受影响。请运行 dws auth login 重新扫码登录。"
        level = "warning"

    return title, msg, level


def _show_windows_toast(title, msg):
    """Windows 10/11 Toast 通知（留在通知中心，不会自动消失）"""
    # 转义 XML 特殊字符
    def _esc(s):
        return (s.replace("&", "&amp;").replace("<", "&lt;")
                 .replace(">", "&gt;").replace('"', "&quot;"))

    xml_body = (
        '<toast duration="long">'
        '<visual><binding template="ToastGeneric">'
        f'<text>{_esc(title)}</text>'
        f'<text>{_esc(msg)}</text>'
        '</binding></visual>'
        '</toast>'
    )
    # PowerShell 单引号字符串中，单引号需要用两个单引号转义
    xml_ps = xml_body.replace("'", "''")
    ps_cmd = (
        '[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null; '
        '[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime] | Out-Null; '
        '$xml = New-Object Windows.Data.Xml.Dom.XmlDocument; '
        f'$xml.LoadXml(\'{xml_ps}\'); '
        '$toast = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("DingTalkSync"); '
        '$toast.Show([Windows.UI.Notifications.ToastNotification]::new($xml))'
    )
    result = subprocess.run(
        ["powershell", "-NoProfile", "-Command", ps_cmd],
        capture_output=True, timeout=10,
        creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
    )
    if result.returncode != 0:
        raise RuntimeError(f"Toast 通知失败: {result.stderr.decode('utf-8', errors='replace')[:200]}")


def _show_windows_balloon(title, msg):
    """Windows 气球通知（兜底方案，兼容旧系统）"""
    # 转义 PowerShell 双引号字符串中的特殊字符
    def _ps_esc(s):
        return s.replace('`', '``').replace('"', '`"').replace("'", "''")
    t = _ps_esc(title)
    m = _ps_esc(msg)
    ps_cmd = (
        '[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null; '
        '$n = New-Object System.Windows.Forms.NotifyIcon; '
        '$n.Icon = [System.Drawing.SystemIcons]::Warning; '
        '$n.Visible = $true; '
        f'$n.ShowBalloonTip(15000, "{t}", "{m}", '
        '[System.Windows.Forms.ToolTipIcon]::Warning); '
        'Start-Sleep -Seconds 18; $n.Dispose()'
    )
    subprocess.Popen(
        ["powershell", "-NoProfile", "-Command", ps_cmd],
        creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
    )


def notify_auth_expired(status):
    """
    认证过期通知（通用，不绑定特定用户）：
      1. auth_alert.json 标志文件 → 供后续 Qt 程序监听并弹出登录窗口
      2. Windows Toast 通知 (Win10/11) → 留在通知中心
      3. Windows 气球通知 → 兜底
      4. Windows 事件日志 → 可追溯
    """
    title, msg, level = _build_auth_alert_msg(status)

    # ---- 1. 写 auth_alert.json（Qt 程序监听此文件弹出登录窗口）----
    alert = {
        "alert_time": datetime.now().isoformat(),
        "level": level,
        "title": title,
        "message": msg,
        "authenticated": status.get("authenticated"),
        "token_valid": status.get("token_valid"),
        "refresh_token_valid": status.get("refresh_token_valid"),
        "expires_at": status.get("expires_at"),
        "refresh_expires_at": status.get("refresh_expires_at"),
        "hours_left": status.get("hours_left"),
        "refresh_hours_left": status.get("refresh_hours_left"),
        "action": "dws auth login",
        "resolved": False,
    }
    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        with open(AUTH_ALERT_FILE, "w", encoding="utf-8") as f:
            json.dump(alert, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

    # 同时更新 auth_state.json（保持兼容）
    try:
        with open(AUTH_STATE_FILE, "w", encoding="utf-8") as f:
            json.dump(alert, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

    # ---- 2. Windows 桌面通知 ----
    if sys.platform == "win32":
        toast_ok = False
        try:
            _show_windows_toast(title, msg)
            toast_ok = True
        except Exception:
            pass
        if not toast_ok:
            try:
                _show_windows_balloon(title, msg)
            except Exception:
                pass

    # ---- 3. Windows 事件日志（可追溯）----
    try:
        evt_msg = (
            f"钉钉同步认证告警 [{level}]\n"
            f"{msg}\n"
            f"token_valid: {status.get('token_valid')}\n"
            f"refresh_token_valid: {status.get('refresh_token_valid')}\n"
            f"expires_at: {status.get('expires_at')}\n"
            f"操作: 请运行 dws auth login 重新扫码登录"
        )
        # 转义 PowerShell 双引号字符串中的特殊字符
        evt_esc = evt_msg.replace('`', '``').replace('"', '`"').replace("'", "''")
        subprocess.run(
            ["powershell", "-NoProfile", "-Command",
             f'Write-EventLog -LogName Application -Source "Application" '
             f'-EventId 9001 -EntryType Warning -Message "{evt_esc}"'],
            capture_output=True, timeout=5,
            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
        )
    except Exception:
        pass

    log(f"认证告警已发送: {title}", "WARN")


def save_auth_state(status):
    """保存当前认证状态快照；认证正常时清除告警标志"""
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

    # 认证正常 → 清除告警标志（Qt 程序据此关闭登录弹窗）
    if status.get("token_valid") and status.get("authenticated"):
        try:
            if AUTH_ALERT_FILE.exists():
                alert_data = {}
                try:
                    alert_data = json.loads(AUTH_ALERT_FILE.read_text(encoding="utf-8"))
                except Exception:
                    pass
                alert_data["resolved"] = True
                alert_data["resolved_at"] = datetime.now().isoformat()
                with open(AUTH_ALERT_FILE, "w", encoding="utf-8") as f:
                    json.dump(alert_data, f, ensure_ascii=False, indent=2)
        except Exception:
            pass


def grant_cross_org_auth(ttl="24h"):
    """
    授予跨组织聊天数据访问权限（timed 授权）。
    跨组织会话的 conversation-info（含 spaceId/newCSpaceIdIM）需要此授权才能获取，
    否则跨组织会话中分享的文件无法解析 spaceId 而下载失败。
    失败不影响主流程，仅记录警告。返回是否成功。
    """
    if not DWS_CORE:
        return False
    cmd = [DWS_CORE, "chat", "data-auth", "cross-org", "--all",
           "--grant-type", "timed", "--ttl", ttl, "--format", "json", "-y"]
    try:
        result = subprocess.run(cmd, capture_output=True, timeout=30,
                                creationflags=_CREATE_NO_WINDOW)
        out = result.stdout.decode("utf-8", errors="replace").strip()
        if result.returncode == 0:
            try:
                data = json.loads(out)
                if data.get("success"):
                    log(f"  跨组织访问授权成功 (有效期 {ttl})")
                    return True
            except json.JSONDecodeError:
                pass
        log("  跨组织访问授权未成功 (不影响本组织同步)", "WARN")
        return False
    except Exception as e:
        log(f"  跨组织授权调用异常: {e}", "WARN")
        return False


def ensure_auth():
    """
    认证保障入口。
    策略:
      1. token 有效且 > 48h -> 正常继续
      2. token 有效但 < 48h -> 尝试静默刷新，继续
      3. token 过期但 refresh 有效 -> 尝试静默刷新
      4. refresh 也过期 -> 通知用户，中止
    返回 (ok: bool, message: str)
    """
    log("检查认证状态...")
    status = check_auth_status()

    if status.get("error"):
        log(f"认证状态检查失败: {status['error']}", "WARN")
        log("无法确认认证状态，尝试继续运行...", "WARN")
        return True, "认证状态未知，乐观继续"

    authenticated = status.get("authenticated", False)
    token_valid = status.get("token_valid", False)
    refresh_valid = status.get("refresh_token_valid", False)
    hours_left = status.get("hours_left")
    refresh_hours = status.get("refresh_hours_left")

    token_info = ""
    if hours_left is not None:
        token_info = f"token 剩余 {hours_left:.0f}h" if hours_left > 24 else f"token 剩余 {hours_left:.1f}h"
    if refresh_hours is not None:
        r_info = f"refresh 剩余 {refresh_hours:.0f}h" if refresh_hours > 24 else f"refresh 剩余 {refresh_hours:.1f}h"
        token_info += f", {r_info}"
    if token_info:
        log(f"  {token_info}")

    if not authenticated:
        log("认证已失效 (authenticated=false)", "ERROR")
        notify_auth_expired(status)
        return False, "认证已失效，需要重新登录"

    if not token_valid and refresh_valid:
        log("Access token 已过期，尝试自动刷新...")
        ok, msg = try_auth_refresh()
        if ok:
            log(f"  自动刷新成功: {msg}")
            new_status = check_auth_status()
            save_auth_state(new_status)
            grant_cross_org_auth()
            return True, "token 已自动刷新"
        else:
            log(f"  自动刷新失败: {msg}", "ERROR")
            notify_auth_expired(status)
            return False, f"自动刷新失败: {msg}"

    if not token_valid and not refresh_valid:
        log("Token 和 Refresh Token 均已过期", "ERROR")
        notify_auth_expired(status)
        return False, "Token 和 Refresh Token 均已过期，需要重新扫码登录"

    save_auth_state(status)
    grant_cross_org_auth()

    if hours_left is not None and hours_left < AUTH_WARN_HOURS:
        log(f"Token 将在 {hours_left:.1f}h 后过期，本次同步正常继续", "WARN")
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
    line = f"[{ts}] [{level}] {msg}"
    try:
        print(line, flush=True)
    except UnicodeEncodeError:
        enc = getattr(sys.stdout, "encoding", None) or "utf-8"
        safe = line.encode(enc, errors="replace").decode(enc, errors="replace")
        print(safe, flush=True)


def write_log(msg):
    """写入同步日志文件（失败不中断同步）"""
    try:
        ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        SYNC_LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
        with open(SYNC_LOG_FILE, "a", encoding="utf-8") as f:
            f.write(f"[{ts}] {msg}\n")
    except Exception:
        pass  # 日志写入失败不应中断同步


def find_dws_core(config_path=""):
    """自动检测 dws-core 可执行文件路径"""
    global DWS_CORE
    candidates = []

    # 打包模式: 优先从程序目录的 bin/ 下查找
    if getattr(sys, "frozen", False):
        _exe_dir = Path(sys.executable).parent
        candidates.append(_exe_dir / "bin" / "dws-core-windows-amd64.exe")
        candidates.append(_exe_dir / "bin" / "dws-core-windows-arm64.exe")

    if config_path:
        cp = Path(config_path)
        candidates.append(cp if cp.is_absolute() else (BASE_DIR / cp).resolve())

    env_dws = os.environ.get("DWS_CORE_PATH")
    if env_dws:
        candidates.append(Path(env_dws))

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

    candidates.append(Path("dws"))

    for c in candidates:
        try:
            result = subprocess.run([str(c), "--version"], capture_output=True, timeout=10,
                                    creationflags=_CREATE_NO_WINDOW)
            if result.returncode == 0:
                DWS_CORE = str(c)
                version = result.stdout.decode("utf-8", errors="replace").strip()
                log(f"找到 DWS: {DWS_CORE} ({version})")
                return True
        except (FileNotFoundError, subprocess.TimeoutExpired):
            continue

    log("未找到 dws-core 可执行文件！", "ERROR")
    log("请确保已安装 QoderWork，或在 sync_config.json 的 paths.dws_core 中指定路径", "ERROR")
    return False


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


# ============================================================
# DWS 命令封装
# ============================================================

def dws_call(args, timeout=30):
    """调用 dws-core 命令，返回解析后的 JSON"""
    if not DWS_CORE:
        log("DWS 未初始化", "ERROR")
        return None

    cmd = [DWS_CORE] + args
    try:
        result = subprocess.run(cmd, capture_output=True, timeout=timeout,
                                creationflags=_CREATE_NO_WINDOW)
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
        if stdout:
            try:
                return json.loads(stdout)
            except json.JSONDecodeError:
                pass
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


def fetch_conversations_dynamic():
    """动态获取会话列表（合并静态文件，自动发现新会话）"""
    convs = load_json(CONVS_FILE)
    existing_map = {c["convId"]: c for c in convs} if convs else {}

    data = dws_call(["chat", "+conversation-list", "--limit", "100", "-y"], timeout=30)
    if not data or data.get("_error") or "error" in data:
        if existing_map:
            log("动态获取会话列表失败，使用本地缓存", "WARN")
            return list(existing_map.values())
        return []

    dynamic_convs = data.get("conversations", [])
    new_count = 0
    for dc in dynamic_convs:
        cid = dc.get("openConversationId", "")
        name = dc.get("conversationName", "")
        if not cid:
            continue
        if cid not in existing_map:
            existing_map[cid] = {
                "convId": cid,
                "title": name,
                "singleChat": False,
                "source": "dynamic",
            }
            new_count += 1
        elif name and not existing_map[cid].get("title"):
            existing_map[cid]["title"] = name

    result = list(existing_map.values())
    if new_count > 0:
        save_json(CONVS_FILE, result)
        log(f"会话列表已更新: {len(result)} 个 (新增 {new_count})")
    return result


def list_messages(conv_id, start_time, limit=200):
    """获取会话消息列表，返回 (messages, has_more)"""
    data = dws_call([
        "chat", "message", "list",
        "--group", conv_id, "--time", start_time, "--limit", str(limit)
    ], timeout=60)
    if not data or data.get("_error"):
        return [], False
    messages = data.get("result", {}).get("messages", [])
    return messages, len(messages) >= limit


def get_conversation_info(conv_id):
    """获取会话信息，返回 (title, space_id)"""
    data = dws_call(["chat", "conversation-info", "--group", conv_id])
    if not data or not isinstance(data, dict) or data.get("_error") or "error" in data:
        return None, None
    conv_info = data.get("result", {}).get("conversationInfo", {})
    title = conv_info.get("title", "")
    ext = conv_info.get("extension", {})
    space_id = ext.get("newCSpaceIdIM", "")
    if not isinstance(space_id, str):
        space_id = ""
    return title, space_id


def get_valid_space_id(conv_id, space_ids_cache):
    """获取有效的 spaceId，如果缓存中的值无效则重新获取"""
    sid = space_ids_cache.get(conv_id, "")
    if isinstance(sid, str) and sid:
        return sid
    # 缓存无效，重新获取
    time.sleep(REQUEST_INTERVAL)
    title, new_sid = get_conversation_info(conv_id)
    if new_sid:
        space_ids_cache[conv_id] = new_sid
        return new_sid
    return ""


def download_file_dws(file_id, dest_path, space_id="", timeout=120):
    """通过 dws drive download --node 直接下载钉盘文件，返回 (success, error_msg)"""
    dest_path = Path(dest_path)
    dest_path.parent.mkdir(parents=True, exist_ok=True)

    cmd = [DWS_CORE, "drive", "download", "--node", file_id, "--output", str(dest_path), "-y"]
    if space_id and isinstance(space_id, str) and space_id.isdigit():
        cmd += ["--space-id", space_id]

    try:
        result = subprocess.run(cmd, capture_output=True, timeout=timeout,
                                creationflags=_CREATE_NO_WINDOW)
        stdout = result.stdout.decode("utf-8", errors="replace").strip()
        stderr = result.stderr.decode("utf-8", errors="replace").strip()

        if result.returncode == 0 and dest_path.exists() and dest_path.stat().st_size > 0:
            return True, ""

        # 解析错误信息
        err_msg = ""
        for raw in (stderr, stdout):
            if raw:
                try:
                    err_data = json.loads(raw)
                    err_obj = err_data.get("error", err_data)
                    err_msg = err_obj.get("message", "") or err_obj.get("_message", "") or str(err_obj)
                    break
                except (json.JSONDecodeError, AttributeError):
                    err_msg = raw[:200]
        if not err_msg:
            err_msg = f"exit code {result.returncode}"

        # 清理可能的不完整文件
        if dest_path.exists() and dest_path.stat().st_size == 0:
            dest_path.unlink()
        return False, err_msg
    except subprocess.TimeoutExpired:
        return False, "下载超时"
    except Exception as e:
        return False, str(e)


def list_drive_space(space_id, folder_id="", limit=50):
    """列出钉盘空间中的文件/文件夹，返回 items 列表"""
    cmd = ["drive", "list", "--space-id", str(space_id), "--limit", str(limit), "-y"]
    if folder_id:
        cmd += ["--folder", folder_id]
    data = dws_call(cmd, timeout=30)
    if not data or data.get("_error") or "error" in data:
        return []
    return data.get("result", {}).get("items", [])


def download_folder_recursive(space_id, folder_id, folder_name, dest_dir, depth=0, max_depth=5, force=False):
    """递归下载文件夹中的所有文件，返回 (downloaded_count, failed_count)"""
    if depth > max_depth:
        log(f"  {'  ' * depth}文件夹层级过深，跳过: {folder_name}", "WARN")
        return 0, 0

    items = list_drive_space(space_id, folder_id)
    if not items:
        return 0, 0

    downloaded = 0
    failed = 0
    folder_dest = Path(dest_dir) / safe_dirname(folder_name)
    folder_dest.mkdir(parents=True, exist_ok=True)

    for item in items:
        if is_cancelled():
            log("用户取消文件夹下载", "WARN")
            return downloaded, failed

        item_type = item.get("type", "")
        item_name = item.get("name", "unknown")
        item_file_id = item.get("fileId", "")

        if item_type == "FOLDER":
            sub_dl, sub_fail = download_folder_recursive(
                space_id, item_file_id, item_name, folder_dest, depth + 1, max_depth, force=force
            )
            downloaded += sub_dl
            failed += sub_fail
        elif item_type == "FILE" and item_file_id:
            file_dest = folder_dest / safe_filename(item_name)
            if file_dest.exists():
                if force:
                    log(f"  {'  ' * depth}  强制覆盖: {item_name}")
                    try:
                        file_dest.unlink()
                    except OSError:
                        pass
                else:
                    downloaded += 1
                    continue
            time.sleep(REQUEST_INTERVAL)
            ok, err = download_file_dws(item_file_id, file_dest, space_id)
            if ok:
                downloaded += 1
                fsize = file_dest.stat().st_size
                log(f"  {'  ' * depth}  下载: {item_name} ({format_size(fsize)})")
            else:
                failed += 1
                log(f"  {'  ' * depth}  失败: {item_name} - {err}", "WARN")

    return downloaded, failed


# ============================================================
# 文件消息解析
# ============================================================

def extract_file_messages(messages):
    """从消息列表中提取文件消息，同时从钉钉深度链接中补全 spaceId"""
    # 第一遍: 从所有消息的 dingtalk:// URL 中建立 fileId -> spaceId 映射
    fid_to_space = {}
    for msg in messages:
        if not isinstance(msg, dict):
            continue
        content = msg.get("content", "")
        for m in DINGTALK_URL_RE.finditer(content):
            # 正则有两个分支: (spaceId, fileId) 或 (fileId, spaceId)
            if m.group(1) and m.group(2):
                fid_to_space[m.group(2)] = m.group(1)
            elif m.group(3) and m.group(4):
                fid_to_space[m.group(3)] = m.group(4)

    # 第二遍: 提取 [文件] 格式消息
    files = []
    for msg in messages:
        if not isinstance(msg, dict):
            continue
        content = msg.get("content", "")
        match = FILE_MSG_RE.search(content)
        if match:
            sender = msg.get("sender", "")
            if isinstance(sender, dict):
                sender = sender.get("name", "")
            fid = match.group(2).strip()
            rec = {
                "fileId": fid,
                "filename": match.group(1).strip(),
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
            }
            # 从 URL 映射中补全 spaceId
            if fid in fid_to_space:
                rec["spaceId"] = fid_to_space[fid]
            files.append(rec)
    return files


def extract_media_messages(messages):
    """从消息列表中提取图片和视频消息（含 mediaId）"""
    media_list = []
    for msg in messages:
        if not isinstance(msg, dict):
            continue
        content = msg.get("content", "")
        sender = msg.get("sender", "")
        if isinstance(sender, dict):
            sender = sender.get("name", "")

        # 图片消息（带 mediaId）
        img_matches = IMAGE_MSG_RE.findall(content)
        for media_id in img_matches:
            media_id = media_id.strip()
            media_list.append({
                "mediaId": media_id,
                "mediaType": "image",
                "openMessageId": msg.get("openMessageId", ""),
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
            })

        # 视频消息（带 mediaId）
        vid_matches = VIDEO_MSG_RE.findall(content)
        for media_id in vid_matches:
            media_id = media_id.strip()
            media_list.append({
                "mediaId": media_id,
                "mediaType": "video",
                "openMessageId": msg.get("openMessageId", ""),
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
            })

        # 简单 [图片] 标记（无 mediaId）
        if not img_matches and IMAGE_SIMPLE_RE.search(content):
            media_list.append({
                "mediaId": "",
                "mediaType": "image",
                "openMessageId": msg.get("openMessageId", ""),
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
                "_noMediaId": True,
            })

        # 简单 [视频] 标记（无 mediaId）
        if not vid_matches and VIDEO_SIMPLE_RE.search(content):
            media_list.append({
                "mediaId": "",
                "mediaType": "video",
                "openMessageId": msg.get("openMessageId", ""),
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
                "_noMediaId": True,
            })

    return media_list


def extract_folder_messages(messages):
    """从消息列表中提取文件夹分享消息"""
    folders = []
    for msg in messages:
        if not isinstance(msg, dict):
            continue
        content = msg.get("content", "")
        match = FOLDER_MSG_RE.search(content)
        if match:
            sender = msg.get("sender", "")
            if isinstance(sender, dict):
                sender = sender.get("name", "")
            folders.append({
                "folderName": match.group(1).strip(),
                "createTime": msg.get("createTime", ""),
                "senderName": msg.get("senderName", sender),
            })
    return folders


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
    """原子保存 JSON 文件（先写临时再替换，防止崩溃损坏）"""
    filepath = Path(filepath)
    filepath.parent.mkdir(parents=True, exist_ok=True)
    tmp_path = filepath.with_suffix(".tmp")
    try:
        with open(tmp_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        # Windows 下目标文件可能被杀毒/索引短暂锁定，重试几次
        for _attempt in range(5):
            try:
                os.replace(str(tmp_path), str(filepath))
                break
            except PermissionError:
                if _attempt < 4:
                    time.sleep(0.3 * (_attempt + 1))
                else:
                    raise
    except Exception:
        # 清理临时文件
        try:
            if tmp_path.exists():
                tmp_path.unlink()
        except Exception:
            pass
        raise


def load_manifest():
    records = load_json(MANIFEST_FILE, [])
    return {r["fileId"]: r for r in records if "fileId" in r}


def save_manifest(manifest_dict):
    save_json(MANIFEST_FILE, list(manifest_dict.values()))


def load_space_ids():
    return load_json(SPACE_IDS_FILE, {})


def save_space_ids(space_ids):
    save_json(SPACE_IDS_FILE, space_ids)


def load_image_manifest():
    records = load_json(IMAGE_MANIFEST_FILE, [])
    return {r["mediaId"]: r for r in records if "mediaId" in r and r["mediaId"]}


def save_image_manifest(manifest_dict):
    save_json(IMAGE_MANIFEST_FILE, list(manifest_dict.values()))


# ---- 断点续传 checkpoint ----
CHECKPOINT_FILE = STATE_DIR / "checkpoint.json"

def save_checkpoint(data):
    """保存同步进度检查点"""
    data["_ts"] = datetime.now().isoformat()
    save_json(CHECKPOINT_FILE, data)

def load_checkpoint():
    """加载检查点，不存在返回 None"""
    return load_json(CHECKPOINT_FILE, None)

def clear_checkpoint():
    """清除检查点（同步完成后调用）"""
    try:
        if CHECKPOINT_FILE.exists():
            CHECKPOINT_FILE.unlink()
    except Exception:
        pass


# ---- 失败文件重试 ----
# retry_failed_files() 定义在下方下载功能区


# ============================================================
# 下载功能
# ============================================================

def safe_filename(name):
    """转换为安全文件名"""
    name = re.sub(r'[<>:"/\\|?*]', '_', name).strip()
    if len(name) > 200:
        base, ext = os.path.splitext(name)
        name = base[:200 - len(ext)] + ext
    return name


def safe_dirname(name):
    """转换为安全目录名"""
    name = safe_filename(name).replace("/", "_").replace("\\", "_")
    return name or "unknown"


def download_file(url, dest_path, timeout=120):
    """从 URL 下载文件"""
    dest_path = Path(dest_path)
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", f"DingTalkSync/{__version__}")
        with urllib.request.urlopen(req, timeout=timeout) as response:
            tmp_path = dest_path.with_suffix(dest_path.suffix + ".tmp")
            with open(tmp_path, "wb") as f:
                while True:
                    chunk = response.read(8192)
                    if not chunk:
                        break
                    f.write(chunk)
            os.replace(str(tmp_path), str(dest_path))
        return True
    except (urllib.error.URLError, urllib.error.HTTPError, OSError) as e:
        log(f"  下载失败: {e}", "WARN")
        tmp_path = dest_path.with_suffix(dest_path.suffix + ".tmp")
        if tmp_path.exists():
            tmp_path.unlink()
        return False


def download_media_dws(media_id, msg_id, conv_id, output_path):
    """
    通过 dws chat message download-media 命令直接下载媒体文件（图片/视频）。
    返回 (success: bool, error_msg: str)
    若 @ 前缀失败（RESOURCE_NOT_FOUND），自动尝试 $ 前缀（旧清单的兼容处理）。
    """
    if not DWS_CORE:
        return False, "DWS 未初始化"

    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    def _try(resource_id):
        cmd = [
            DWS_CORE, "chat", "message", "download-media",
            "--type", "mediaId",
            "--resource-id", resource_id,
            "--message-id", msg_id,
            "--open-conversation-id", conv_id,
            "--output", str(output_path),
        ]
        try:
            result = subprocess.run(cmd, capture_output=True, timeout=120,
                                    creationflags=_CREATE_NO_WINDOW)
            stdout = result.stdout.decode("utf-8", errors="replace").strip()
            stderr = result.stderr.decode("utf-8", errors="replace").strip()

            if result.returncode == 0:
                if output_path.exists() and output_path.stat().st_size > 0:
                    return True, ""
                if output_path.is_dir():
                    files = list(output_path.iterdir())
                    if files:
                        return True, ""
                return False, "命令成功但文件未生成"

            err_msg = stderr or stdout or f"exit code {result.returncode}"
            try:
                err_data = json.loads(stderr or stdout)
                err_obj = err_data.get("error", err_data)
                err_msg = err_obj.get("message", str(err_obj))
            except (json.JSONDecodeError, TypeError):
                err_msg = err_msg[:300]
            return False, err_msg

        except subprocess.TimeoutExpired:
            return False, "下载超时 (120s)"
        except Exception as e:
            return False, str(e)

    ok, err_msg = _try(media_id)
    if ok:
        return True, ""

    # 兼容回退: @ 前缀失败时尝试 $ 前缀
    if media_id.startswith("@") and "120s" not in err_msg:
        alt_id = "$" + media_id[1:]
        ok2, err2 = _try(alt_id)
        if ok2:
            return True, ""
        return False, err2

    return False, err_msg


def download_image_native_api(access_token, media_id, dest_path):
    """通过钉钉原生 media download API 下载图片"""
    if not access_token:
        return False, "未配置 access_token"

    url = f"https://oapi.dingtalk.com/media/download?access_token={access_token}&media_id={media_id}"
    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", f"DingTalkSync/{__version__}")
        with urllib.request.urlopen(req, timeout=60) as response:
            content_type = response.headers.get("Content-Type", "")
            if "json" in content_type or "text/plain" in content_type:
                body = response.read().decode("utf-8", errors="replace")
                try:
                    err_data = json.loads(body)
                    return False, f"API error: {err_data.get('errmsg', body[:200])}"
                except json.JSONDecodeError:
                    return False, f"Unexpected: {body[:200]}"

            dest_path = Path(dest_path)
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            ext_map = {"image/jpeg": ".jpg", "image/png": ".png", "image/gif": ".gif",
                       "image/webp": ".webp", "image/bmp": ".bmp"}
            for ct, ext in ext_map.items():
                if ct in content_type:
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
            os.replace(str(tmp_path), str(dest_path))
            return True, ""
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")[:300] if e.fp else ""
        return False, f"HTTP {e.code}: {body}"
    except Exception as e:
        return False, str(e)


# ============================================================
# 核心同步逻辑
# ============================================================

def fetch_messages_bulk(start_time, end_time, limit=50, max_pages=0):
    """
    通过 dws chat message list-all 批量拉取时间范围内的所有消息。
    返回 {convId: {"title": ..., "messages": [...]}, ...}
    如果 API 不可用（无权益等），返回 None。
    max_pages=0 表示不限制页数，拉取直到没有更多数据。
    """
    conv_map = {}
    cursor = "0"
    page = 0
    total_msgs = 0

    while max_pages <= 0 or page < max_pages:
        page += 1
        cmd = ["chat", "message", "list-all",
               "--start", start_time, "--end", end_time,
               "--limit", str(limit), "--cursor", cursor, "-y"]
        data = dws_call(cmd, timeout=60)

        if data is None:
            if page == 1:
                return None  # 首页就失败，API 不可用
            break

        # 检查权限错误
        if isinstance(data, dict) and not data.get("success", True):
            err_msg = str(data.get("message", data.get("error", "")))
            if "权益" in err_msg or "permission" in err_msg.lower():
                log(f"  list-all 无消息搜索权益，回退到逐会话扫描", "WARN")
                return None
            if page == 1:
                return None

        result = data.get("result", data)
        conv_list = result.get("conversationMessagesList", [])

        for conv_item in conv_list:
            conv_id = conv_item.get("openConversationId", "")
            title = conv_item.get("title", "")
            messages = conv_item.get("messages", [])
            if not conv_id:
                continue
            if conv_id not in conv_map:
                conv_map[conv_id] = {"title": title, "messages": []}
            conv_map[conv_id]["messages"].extend(messages)
            total_msgs += len(messages)

        has_more = result.get("hasMore", False)
        next_cursor = result.get("nextCursor", "")

        if page % 5 == 0:
            log(f"  批量拉取: 第{page}页, 累计 {total_msgs} 条消息, {len(conv_map)} 个会话")

        if not has_more or not next_cursor:
            break
        cursor = next_cursor
        time.sleep(REQUEST_INTERVAL)

    if max_pages > 0 and page >= max_pages:
        log(f"  批量拉取达到页数上限 ({max_pages})，数据可能不完整", "WARN")
    log(f"  批量拉取完成: {page} 页, {total_msgs} 条消息, {len(conv_map)} 个会话")
    hit_limit = (max_pages > 0 and page >= max_pages)
    return conv_map, hit_limit


def scan_conversations_bulk(convs, start_time, end_time, space_ids_cache):
    """
    使用 list-all 批量扫描所有会话。
    返回 (files_found, images_found, folders_found, scanned_count, error_count)
    如果 list-all 不可用，返回 None。
    """
    log("  尝试 list-all 批量拉取...")
    result = fetch_messages_bulk(start_time, end_time)
    if result is None:
        return None
    conv_map, hit_limit = result
    if conv_map is None:
        return None
    if hit_limit:
        log("  批量拉取触顶，数据不完整，回退到逐会话扫描", "WARN")
        return None

    # 建立 convId -> conv 映射（用于匹配已知会话）
    known_convs = {c["convId"]: c for c in convs}

    all_files = []
    all_images = []
    all_folders = []
    scanned = 0

    for conv_id, conv_data in conv_map.items():
        title = conv_data["title"] or known_convs.get(conv_id, {}).get("title", conv_id[:20])
        messages = conv_data["messages"]
        scanned += 1

        for fm in extract_file_messages(messages):
            fm["convId"] = conv_id
            fm["convTitle"] = title
            all_files.append(fm)

        for im in extract_media_messages(messages):
            im["convId"] = conv_id
            im["convTitle"] = title
            all_images.append(im)

        for folder in extract_folder_messages(messages):
            folder["convId"] = conv_id
            folder["convTitle"] = title
            all_folders.append(folder)

        # 获取 spaceId（文件/文件夹下载需要）
        if (all_files or all_folders) and conv_id not in space_ids_cache:
            time.sleep(REQUEST_INTERVAL)
            _, space_id = get_conversation_info(conv_id)
            if space_id:
                space_ids_cache[conv_id] = space_id

    return all_files, all_images, all_folders, scanned, 0


def scan_conversation(conv_id, conv_title, start_time, space_ids_cache):
    """扫描单个会话，返回 (files_found, images_found, folders_found)"""
    files_found = []
    images_found = []
    folders_found = []
    current_time = start_time

    while True:
        time.sleep(REQUEST_INTERVAL)
        messages, has_more = list_messages(conv_id, current_time)
        if not messages:
            break

        for fm in extract_file_messages(messages):
            fm["convId"] = conv_id
            fm["convTitle"] = conv_title
            files_found.append(fm)

        for im in extract_media_messages(messages):
            im["convId"] = conv_id
            im["convTitle"] = conv_title
            images_found.append(im)

        for folder in extract_folder_messages(messages):
            folder["convId"] = conv_id
            folder["convTitle"] = conv_title
            folders_found.append(folder)

        if not has_more:
            break
        last_time = messages[-1].get("createTime", "")
        if not last_time or last_time == current_time:
            break
        current_time = last_time

    if (files_found or folders_found) and conv_id not in space_ids_cache:
        time.sleep(REQUEST_INTERVAL)
        title, space_id = get_conversation_info(conv_id)
        if space_id:
            space_ids_cache[conv_id] = space_id

    return files_found, images_found, folders_found


def retry_failed_media(dingtalk_token=""):
    """重试之前失败的媒体文件（图片/视频），优先用 dws download-media"""
    image_manifest = load_image_manifest()
    retry_candidates = []
    for mid, record in image_manifest.items():
        if not record.get("_pending"):
            continue
        if record.get("mediaId"):
            retry_candidates.append(record)

    if not retry_candidates:
        log("没有需要重试的媒体文件")
        return 0, 0

    log("=" * 50)
    log(f"重试失败的媒体文件 ({len(retry_candidates)} 个)")
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
        conv_id = record.get("convId", "")
        media_type = record.get("mediaType", "image")
        progress = f"[{i+1}/{len(retry_candidates)}]"

        date_str = create_time[:10] if create_time else "unknown"
        safe_title = safe_dirname(conv_title)
        media_dir = IMAGE_DIR / safe_title / date_str
        mid_hash = hashlib.md5(mid.encode()).hexdigest()[:12]
        default_ext = ".mp4" if media_type == "video" else ".jpg"
        media_path = media_dir / f"{mid_hash}{default_ext}"

        # 检查是否已存在
        existing = list(media_dir.glob(f"{mid_hash}.*")) if media_dir.exists() else []
        if existing:
            success += 1
            record["_downloaded"] = True
            record.pop("_pending", None)
            record.pop("_error", None)
            record["_localPath"] = str(existing[0])
            image_manifest[mid] = record
            continue

        # 优先用 dws download-media
        time.sleep(REQUEST_INTERVAL)
        ok, err_msg = download_media_dws(mid, msg_id, conv_id, media_path)

        if ok:
            success += 1
            actual_files = list(media_dir.glob(f"{mid_hash}.*"))
            actual_path = actual_files[0] if actual_files else media_path
            file_size = actual_path.stat().st_size if actual_path.exists() else 0
            log(f"  {progress} 重试成功(dws): {safe_title}/{actual_path.name} ({format_size(file_size)})")
            record["_downloaded"] = True
            record["_downloadMethod"] = "dws_download_media_retry"
            record.pop("_pending", None)
            record.pop("_error", None)
            record["_localPath"] = str(actual_path)
        elif dingtalk_token:
            # dws 失败，尝试原生 API
            time.sleep(REQUEST_INTERVAL)
            fb_ok, fb_err = download_image_native_api(dingtalk_token, mid, media_path)
            if fb_ok:
                success += 1
                actual_files = list(media_dir.glob(f"{mid_hash}.*"))
                actual_path = actual_files[0] if actual_files else media_path
                file_size = actual_path.stat().st_size if actual_path.exists() else 0
                log(f"  {progress} 重试成功(native): {safe_title}/{actual_path.name} ({format_size(file_size)})")
                record["_downloaded"] = True
                record["_downloadMethod"] = "native_api_retry"
                record.pop("_pending", None)
                record.pop("_error", None)
                record["_localPath"] = str(actual_path)
            else:
                record["_error"] = f"dws失败({err_msg[:100]}) + 原生API失败({fb_err})"
                log(f"  {progress} 重试失败: {conv_title} - {err_msg[:80]}")
        else:
            record["_error"] = f"dws下载失败: {err_msg[:200]}"
            log(f"  {progress} 重试失败: {conv_title} - {err_msg[:80]}")

        image_manifest[mid] = record
        retried += 1

        if (i + 1) % 20 == 0:
            save_image_manifest(image_manifest)

    save_image_manifest(image_manifest)
    log(f"图片重试完成: 尝试{retried}, 成功{success}")
    write_log(f"图片重试完成: 尝试{retried}, 成功{success}")
    return retried, success


def retry_failed_files():
    """重试之前失败或未尝试的文件下载（使用 dws drive download --node）"""
    manifest = load_manifest()
    space_ids = load_space_ids()
    retry_candidates = []
    for fid, record in manifest.items():
        if record.get("_downloaded") or record.get("_expired"):
            continue
        retry_candidates.append(record)

    if not retry_candidates:
        log("没有需要重试的文件")
        return 0, 0

    # 对数字 fileId 且缺 spaceId 的，尝试从会话消息中补全
    need_space_convs = set()
    for record in retry_candidates:
        fid = record.get("fileId", "")
        sid = record.get("spaceId", "")
        conv_id = record.get("convId", "")
        if fid.isdigit() and not sid and conv_id and conv_id not in space_ids:
            need_space_convs.add(conv_id)

    if need_space_convs:
        log(f"尝试获取 {len(need_space_convs)} 个会话的 spaceId...")
        # 跨组织会话需授权后才能通过 conversation-info 拿到 spaceId
        grant_cross_org_auth()
        for cid in need_space_convs:
            # 优先: conversation-info 的 newCSpaceIdIM（跨组织授权后可用）
            time.sleep(REQUEST_INTERVAL)
            _title, sid_info = get_conversation_info(cid)
            if isinstance(sid_info, str) and sid_info.isdigit():
                space_ids[cid] = sid_info
                continue
            # 回退: 从消息中的钉盘深链接提取 spaceId
            msgs, _ = list_messages(cid, "2020-01-01 00:00:00", limit=200)
            if msgs:
                for msg in msgs:
                    content = msg.get("content", "") if isinstance(msg, dict) else ""
                    for m in DINGTALK_URL_RE.finditer(content):
                        sid_found = m.group(1) or m.group(4)
                        if sid_found:
                            space_ids[cid] = sid_found
                            break
                    if cid in space_ids:
                        break
        save_space_ids(space_ids)

    log("=" * 50)
    log(f"重试失败的文件 ({len(retry_candidates)} 个)")
    log("=" * 50)

    retried = 0
    success = 0

    for i, record in enumerate(retry_candidates):
        fid = record["fileId"]
        fname = record.get("filename", "unknown")
        conv_title = record.get("convTitle", "unknown")
        create_time = record.get("createTime", "")
        sid = record.get("spaceId", "")
        if isinstance(sid, dict):
            sid = sid.get("spaceId", "")
        # 从 space_ids 缓存补全
        if not sid and record.get("convId") in space_ids:
            sid = space_ids[record["convId"]]
            record["spaceId"] = sid
        progress = f"[{i+1}/{len(retry_candidates)}]"

        date_str = create_time[:10] if create_time else "unknown"
        safe_title = safe_dirname(conv_title)
        safe_name = safe_filename(fname)
        dest_path = BASE_DIR / safe_title / date_str / safe_name

        if dest_path.exists():
            success += 1
            record["_downloaded"] = True
            record["_localPath"] = str(dest_path)
            record.pop("_expired", None)
            record.pop("_failed", None)
            record.pop("_error", None)
            manifest[fid] = record
            continue

        sid_str = sid if isinstance(sid, str) else ""
        time.sleep(REQUEST_INTERVAL)
        ok, err_msg = download_file_dws(fid, dest_path, sid_str)

        if ok:
            success += 1
            file_size = dest_path.stat().st_size
            log(f"  {progress} 重试成功: {safe_title}/{safe_name} ({format_size(file_size)})")
            record["_downloaded"] = True
            record["_localPath"] = str(dest_path)
            record.pop("_expired", None)
            record.pop("_failed", None)
            record.pop("_error", None)
        else:
            if "RESOURCE_NOT_FOUND" in err_msg or "not found" in err_msg.lower():
                record["_expired"] = True
                record.pop("_failed", None)
                record.pop("_error", None)
                log(f"  {progress} 已过期/不存在: {fname}")
            else:
                record["_failed"] = True
                record["_error"] = err_msg[:200]
                log(f"  {progress} 重试失败: {fname} - {err_msg[:80]}")

        manifest[fid] = record
        retried += 1

        if (i + 1) % 20 == 0:
            save_manifest(manifest)

    save_manifest(manifest)
    log(f"文件重试完成: 尝试{retried}, 成功{success}")
    write_log(f"文件重试完成: 尝试{retried}, 成功{success}")
    return retried, success


def run_sync(args):
    """执行同步"""
    ensure_dirs()
    clear_cancel()

    force = getattr(args, 'force', False)
    if force:
        log("模式: 强制覆盖（重新下载已同步的文件）")

    dingtalk_token = getattr(args, 'dingtalk_token', '') or ''
    if not dingtalk_token:
        config = load_config()
        if config:
            dingtalk_token = config.get("dingtalk", {}).get("access_token", "")
    if dingtalk_token:
        log(f"钉钉 access_token 已配置（用于图片下载 fallback）")

    convs = fetch_conversations_dynamic()
    if not convs:
        log("无法获取会话列表", "ERROR")
        return 1
    log(f"加载了 {len(convs)} 个会话")

    if args.full:
        start_time = "2020-01-01 00:00:00"
        log("模式: 全量扫描（从 2020 年开始）")
    else:
        days = args.days or 7
        start_dt = datetime.now() - timedelta(days=days)
        start_time = start_dt.strftime("%Y-%m-%d %H:%M:%S")
        log(f"模式: 增量扫描（最近 {days} 天，从 {start_time} 开始）")

    manifest = load_manifest()
    log(f"已有清单: {len(manifest)} 个文件")

    image_manifest = load_image_manifest()
    log(f"媒体清单: {len(image_manifest)} 个")

    space_ids = load_space_ids()

    # 断点续传: 尝试加载上次的检查点
    _ckpt = load_checkpoint()
    _resuming = False
    if _ckpt and _ckpt.get("new_files") is not None:
        _resuming = True
        log(f"发现未完成的同步检查点 ({_ckpt.get('_ts', '?')})，从断点恢复")
        log(f"  跳过扫描阶段，使用缓存的扫描结果")

    # ===== 阶段 1: 扫描 =====
    log("=" * 50)
    log("阶段 1: 扫描会话消息")
    log("=" * 50)

    new_files = []
    new_images = []
    new_folders = []
    scanned = 0
    errors = 0

    if _resuming:
        # 从检查点恢复扫描结果
        new_files = _ckpt.get("new_files", [])
        new_images = _ckpt.get("new_images", [])
        new_folders = _ckpt.get("new_folders", [])
        scanned = _ckpt.get("scanned", 0)
        log(f"  从检查点恢复: {len(new_files)} 文件, {len(new_images)} 媒体, {len(new_folders)} 文件夹, {scanned} 会话")
    else:
        # 优先尝试 list-all 批量扫描（大幅减少 API 调用）
        end_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        use_bulk = not getattr(args, 'no_bulk', False)
        bulk_result = None

        if use_bulk:
            bulk_result = scan_conversations_bulk(convs, start_time, end_time, space_ids)

        if bulk_result is not None:
            # 批量扫描成功
            new_files, new_images, new_folders, scanned, errors = bulk_result
            log(f"  批量扫描完成: {scanned} 个会话")
        else:
            # 回退: 逐会话扫描
            if use_bulk:
                log("  回退到逐会话扫描模式...")
            for i, conv in enumerate(convs):
                if is_cancelled():
                    log("用户取消扫描", "WARN")
                    save_space_ids(space_ids)
                    return -1
                conv_id = conv["convId"]
                conv_title = conv.get("title", conv_id[:20])
                scanned += 1

                if (i + 1) % 5 == 0 or i == 0 or i == len(convs) - 1:
                    log(f"  扫描中 [{i+1}/{len(convs)}] {conv_title}...")

                try:
                    files, images, folders = scan_conversation(conv_id, conv_title, start_time, space_ids)
                    if files:
                        log(f"  [{conv_title}] 发现 {len(files)} 个文件")
                    if images:
                        log(f"  [{conv_title}] 发现 {len(images)} 个媒体")
                    if folders:
                        log(f"  [{conv_title}] 发现 {len(folders)} 个文件夹")

                    new_files.extend(files)
                    new_images.extend(images)
                    new_folders.extend(folders)
                except Exception as e:
                    log(f"  [{conv_title}] 扫描出错: {e}", "ERROR")
                    errors += 1

        # 合并扫描中发现的新会话到 _all_convs.json
        _discovered_ids = set()
        for item in new_files + new_images + new_folders:
            cid = item.get("convId", "")
            if cid:
                _discovered_ids.add(cid)
        if _discovered_ids:
            _existing = {c["convId"] for c in convs}
            _new_convs = []
            for item in new_files + new_images + new_folders:
                cid = item.get("convId", "")
                if cid and cid not in _existing:
                    _existing.add(cid)
                    _new_convs.append({
                        "convId": cid,
                        "title": item.get("convTitle", cid[:20]),
                        "source": "scan_discovered",
                    })
            if _new_convs:
                convs.extend(_new_convs)
                save_json(CONVS_FILE, convs)
                log(f"  发现 {len(_new_convs)} 个新会话，已合并到会话列表 (共 {len(convs)})")

        # 保存检查点（扫描结果）
        save_checkpoint({
            "phase": "scan_done",
            "new_files": new_files,
            "new_images": new_images,
            "new_folders": new_folders,
            "scanned": scanned,
            "full": getattr(args, 'full', False),
            "start_time": start_time,
        })
        log(f"  检查点已保存 (扫描完成)")

    # 文件去重
    if force:
        # 强制覆盖: 包含所有扫描到的文件（即使已在清单中）
        seen_ids = set()
        unique_new = []
        for f in new_files:
            fid = f["fileId"]
            if fid not in seen_ids:
                seen_ids.add(fid)
                unique_new.append(f)
        log(f"强制覆盖模式: 共 {len(unique_new)} 个文件（含已同步）")
    else:
        # 断点恢复时: 只跳过已下载/已过期的，重试未完成的
        if _resuming:
            seen_ids = {fid for fid, info in manifest.items()
                        if info.get("_downloaded") or info.get("_expired")}
            log(f"  断点恢复: 跳过 {len(seen_ids)} 个已完成文件")
        else:
            seen_ids = set(manifest.keys())
        unique_new = []
        for f in new_files:
            fid = f["fileId"]
            if fid not in seen_ids:
                seen_ids.add(fid)
                unique_new.append(f)

    # 媒体去重
    if force:
        seen_img_ids = set()
        unique_new_images = []
        for img in new_images:
            mid = img["mediaId"] or img.get("openMessageId", "")
            if mid and mid not in seen_img_ids:
                seen_img_ids.add(mid)
                unique_new_images.append(img)
        log(f"强制覆盖模式: 共 {len(unique_new_images)} 个媒体（含已同步）")
    else:
        if _resuming:
            seen_img_ids = {mid for mid, info in image_manifest.items()
                           if info.get("_downloaded") and not info.get("_pending")}
            log(f"  断点恢复: 跳过 {len(seen_img_ids)} 个已完成媒体")
        else:
            seen_img_ids = set(image_manifest.keys())
        unique_new_images = []
        for img in new_images:
            mid = img["mediaId"] or img.get("openMessageId", "")
            if mid and mid not in seen_img_ids:
                seen_img_ids.add(mid)
                unique_new_images.append(img)

    # 文件夹去重（同一会话中同名文件夹只保留一个）
    seen_folders = set()
    unique_new_folders = []
    for folder in new_folders:
        key = (folder["convId"], folder["folderName"])
        if key not in seen_folders:
            seen_folders.add(key)
            unique_new_folders.append(folder)

    log(f"扫描完成: {scanned} 个会话, 新文件 {len(unique_new)}, 新媒体 {len(unique_new_images)}, 新文件夹 {len(unique_new_folders)}, 错误 {errors}")

    if not unique_new and not unique_new_images and not unique_new_folders:
        if force:
            log("扫描完成，未发现任何文件/媒体/文件夹")
        else:
            log("没有新文件/媒体/文件夹需要同步")
        save_space_ids(space_ids)
        write_log(f"扫描完成: 无新文件/媒体/文件夹 (扫描 {scanned} 个会话)")
        return 0

    # 补充 spaceId
    need_space = [f for f in unique_new if not f.get("spaceId") and f["convId"] not in space_ids]
    if need_space:
        convs_needing_space = set(f["convId"] for f in need_space)
        log(f"获取 {len(convs_needing_space)} 个会话的 spaceId...")
        for cid in convs_needing_space:
            time.sleep(REQUEST_INTERVAL)
            title, sid = get_conversation_info(cid)
            if sid:
                space_ids[cid] = sid

    # 二次补全: 对仍缺 spaceId 的数字 fileId，从会话消息的 dingtalk:// 链接中提取
    still_need = [f for f in unique_new
                  if not f.get("spaceId") and f["convId"] not in space_ids
                  and f["fileId"].isdigit()]
    if still_need:
        convs_to_probe = set(f["convId"] for f in still_need)
        log(f"尝试从消息链接中提取 {len(convs_to_probe)} 个会话的 spaceId...")
        for cid in convs_to_probe:
            time.sleep(REQUEST_INTERVAL)
            msgs, _ = list_messages(cid, "2020-01-01 00:00:00", limit=200)
            if msgs:
                for msg in msgs:
                    content = msg.get("content", "") if isinstance(msg, dict) else ""
                    for m in DINGTALK_URL_RE.finditer(content):
                        sid_found = m.group(1) or m.group(4)
                        if sid_found:
                            space_ids[cid] = sid_found
                            break
                    if cid in space_ids:
                        break

    for f in unique_new:
        if not f.get("spaceId") and f["convId"] in space_ids:
            f["spaceId"] = space_ids[f["convId"]]

    save_space_ids(space_ids)

    for f in unique_new:
        manifest[f["fileId"]] = {
            "fileId": f["fileId"], "filename": f["filename"],
            "createTime": f.get("createTime", ""), "sender": f.get("senderName", ""),
            "convId": f["convId"], "convTitle": f.get("convTitle", ""),
            "spaceId": f.get("spaceId", ""),
        }
    save_manifest(manifest)
    log(f"清单已更新: {len(manifest)} 个文件")

    if args.scan_only:
        log("仅扫描模式，跳过下载")
        write_log(f"扫描完成: {len(unique_new)} 个新文件 (仅扫描)")
        return 0

    if args.dry_run:
        log("=" * 50)
        log("Dry-run: 以下文件将被下载")
        log("=" * 50)
        for f in unique_new:
            print(f"  {f.get('createTime', '')[:10]} | {f.get('convTitle', '?')} | {f['filename']}")
        log(f"共 {len(unique_new)} 个文件")
        return 0

    # ===== 阶段 2: 下载文件（dws drive download --node） =====
    log("=" * 50)
    log("阶段 2: 下载文件")
    log("=" * 50)

    downloaded = 0
    expired = 0
    failed = 0

    for i, f in enumerate(unique_new):
        if is_cancelled():
            log("用户取消下载", "WARN")
            save_manifest(manifest)
            save_space_ids(space_ids)
            return -1

        fid = f["fileId"]
        fname = f["filename"]
        sid = f.get("spaceId", "")
        conv_title = f.get("convTitle", "unknown")
        create_time = f.get("createTime", "")
        progress = f"[{i+1}/{len(unique_new)}]"

        date_str = create_time[:10] if create_time else "unknown"
        safe_title = safe_dirname(conv_title)
        safe_name = safe_filename(fname)
        dest_path = BASE_DIR / safe_title / date_str / safe_name

        if dest_path.exists():
            if force:
                log(f"  {progress} 强制覆盖: {safe_name}")
                try:
                    dest_path.unlink()
                except OSError:
                    pass
            else:
                downloaded += 1
                log(f"  {progress} 已存在: {safe_name}")
                manifest[fid]["_downloaded"] = True
                manifest[fid]["_localPath"] = str(dest_path)
                continue

        # spaceId 可选，dws drive download --node 不强制要求
        sid_str = sid if isinstance(sid, str) else ""

        time.sleep(REQUEST_INTERVAL)
        log(f"  {progress} 下载中: {fname}...")
        ok, err_msg = download_file_dws(fid, dest_path, sid_str)
        if ok:
            downloaded += 1
            file_size = dest_path.stat().st_size
            log(f"  {progress} 完成: {safe_name} ({format_size(file_size)})")
            manifest[fid]["_downloaded"] = True
            manifest[fid]["_localPath"] = str(dest_path)
            manifest[fid].pop("_expired", None)
            manifest[fid].pop("_failed", None)
        else:
            if "RESOURCE_NOT_FOUND" in err_msg or "not found" in err_msg.lower():
                expired += 1
                log(f"  {progress} 已过期/不存在: {fname}")
                manifest[fid]["_expired"] = True
            else:
                failed += 1
                log(f"  {progress} 下载失败: {fname} - {err_msg[:80]}", "WARN")
                manifest[fid]["_failed"] = True
                manifest[fid]["_error"] = err_msg[:200]

        if (i + 1) % 20 == 0:
            save_manifest(manifest)

    save_manifest(manifest)

    # ===== 阶段 3: 同步图片/视频（dws download-media） =====
    img_downloaded = 0
    img_failed = 0
    img_no_media = 0

    if unique_new_images:
        log("=" * 50)
        log(f"阶段 3: 同步媒体文件 ({len(unique_new_images)} 个)")
        log("=" * 50)
        IMAGE_DIR.mkdir(parents=True, exist_ok=True)

        for i, img in enumerate(unique_new_images):
            if is_cancelled():
                log("用户取消媒体同步", "WARN")
                save_image_manifest(image_manifest)
                return -1

            mid = img["mediaId"]
            conv_title = img.get("convTitle", "unknown")
            sender = img.get("senderName", "")
            create_time = img.get("createTime", "")
            msg_id = img.get("openMessageId", "")
            conv_id = img.get("convId", "")
            media_type = img.get("mediaType", "image")
            progress = f"[{i+1}/{len(unique_new_images)}]"

            if not mid or img.get("_noMediaId"):
                img_no_media += 1
                log(f"  {progress} 无mediaId，仅记录: {conv_title} ({media_type})")
                record_key = mid or msg_id
                image_manifest[record_key] = {
                    "mediaId": mid, "mediaType": media_type,
                    "openMessageId": msg_id,
                    "createTime": create_time, "sender": sender,
                    "convId": conv_id, "convTitle": conv_title,
                    "_noMediaId": True,
                }
                continue

            date_str = create_time[:10] if create_time else "unknown"
            safe_title = safe_dirname(conv_title)
            media_dir = IMAGE_DIR / safe_title / date_str
            mid_hash = hashlib.md5(mid.encode()).hexdigest()[:12]
            default_ext = ".mp4" if media_type == "video" else ".jpg"
            media_filename = f"{mid_hash}{default_ext}"
            media_path = media_dir / media_filename

            # 检查是否已存在（任意扩展名）
            existing = list(media_dir.glob(f"{mid_hash}.*")) if media_dir.exists() else []
            if existing:
                if force:
                    log(f"  {progress} 强制覆盖媒体: {safe_title}/{existing[0].name}")
                    for ex in existing:
                        try:
                            ex.unlink()
                        except OSError:
                            pass
                else:
                    img_downloaded += 1
                    log(f"  {progress} 已存在: {safe_title}/{existing[0].name}")
                    image_manifest[mid] = {
                        "mediaId": mid, "mediaType": media_type,
                        "openMessageId": msg_id,
                        "createTime": create_time, "sender": sender,
                        "convId": conv_id, "convTitle": conv_title,
                        "_downloaded": True, "_localPath": str(existing[0]),
                    }
                    continue

            # 使用 dws chat message download-media 下载
            time.sleep(REQUEST_INTERVAL)
            log(f"  {progress} 下载中({media_type}): {conv_title}/{media_filename}...")
            ok, err_msg = download_media_dws(mid, msg_id, conv_id, media_path)

            if ok:
                img_downloaded += 1
                # 检查实际下载的文件（dws 可能自动推断扩展名）
                actual_files = list(media_dir.glob(f"{mid_hash}.*"))
                actual_path = actual_files[0] if actual_files else media_path
                file_size = actual_path.stat().st_size if actual_path.exists() else 0
                log(f"  {progress} 完成: {actual_path.name} ({format_size(file_size)})")
                image_manifest[mid] = {
                    "mediaId": mid, "mediaType": media_type,
                    "openMessageId": msg_id,
                    "createTime": create_time, "sender": sender,
                    "convId": conv_id, "convTitle": conv_title,
                    "_downloaded": True, "_downloadMethod": "dws_download_media",
                    "_localPath": str(actual_path),
                }
            else:
                # dws download-media 失败，尝试原生 API fallback
                fallback_ok = False
                if dingtalk_token:
                    log(f"  {progress} dws 下载失败，尝试原生 API: {err_msg[:80]}")
                    time.sleep(REQUEST_INTERVAL)
                    fb_ok, fb_err = download_image_native_api(dingtalk_token, mid, media_path)
                    if fb_ok:
                        fallback_ok = True
                        img_downloaded += 1
                        actual_files = list(media_dir.glob(f"{mid_hash}.*"))
                        actual_path = actual_files[0] if actual_files else media_path
                        file_size = actual_path.stat().st_size if actual_path.exists() else 0
                        log(f"  {progress} 完成(native): {actual_path.name} ({format_size(file_size)})")
                        image_manifest[mid] = {
                            "mediaId": mid, "mediaType": media_type,
                            "openMessageId": msg_id,
                            "createTime": create_time, "sender": sender,
                            "convId": conv_id, "convTitle": conv_title,
                            "_downloaded": True, "_downloadMethod": "native_api",
                            "_localPath": str(actual_path),
                        }
                    else:
                        err_msg = f"dws失败({err_msg[:100]}) + 原生API失败({fb_err})"

                if not fallback_ok:
                    img_failed += 1
                    log(f"  {progress} 下载失败: {conv_title} - {err_msg[:120]}")
                    image_manifest[mid] = {
                        "mediaId": mid, "mediaType": media_type,
                        "openMessageId": msg_id,
                        "createTime": create_time, "sender": sender,
                        "convId": conv_id, "convTitle": conv_title,
                        "_pending": True, "_error": err_msg[:300],
                    }

            if (i + 1) % 20 == 0:
                save_image_manifest(image_manifest)

        save_image_manifest(image_manifest)
        log(f"媒体同步完成: 下载{img_downloaded}, 失败{img_failed}, 无mediaId{img_no_media}")
    elif unique_new:
        save_image_manifest(image_manifest)

    # ===== 阶段 4: 同步文件夹（群文件/共享文件夹） =====
    folder_downloaded = 0
    folder_failed = 0
    folder_synced = 0

    if unique_new_folders:
        log("=" * 50)
        log(f"阶段 4: 同步文件夹 ({len(unique_new_folders)} 个)")
        log("=" * 50)

        for i, folder in enumerate(unique_new_folders):
            if is_cancelled():
                log("用户取消文件夹同步", "WARN")
                save_space_ids(space_ids)
                return -1

            folder_name = folder["folderName"]
            conv_id = folder["convId"]
            conv_title = folder.get("convTitle", "unknown")
            progress = f"[{i+1}/{len(unique_new_folders)}]"

            # 获取会话的 spaceId（自动验证和重新获取）
            sid = get_valid_space_id(conv_id, space_ids)

            if not sid:
                log(f"  {progress} 无法获取 spaceId，跳过: {conv_title}/{folder_name}", "WARN")
                folder_failed += 1
                continue

            # 在空间根目录中查找匹配的文件夹
            time.sleep(REQUEST_INTERVAL)
            items = list_drive_space(sid)
            target_item = None
            for item in items:
                if item.get("type") == "FOLDER" and item.get("name") == folder_name:
                    target_item = item
                    break

            if not target_item:
                log(f"  {progress} 未在空间中找到文件夹: {conv_title}/{folder_name}", "WARN")
                folder_failed += 1
                continue

            # 递归下载文件夹
            log(f"  {progress} 同步文件夹: {conv_title}/{folder_name}...")
            safe_title = safe_dirname(conv_title)
            folder_dest = BASE_DIR / safe_title / "_folders"
            dl, fail = download_folder_recursive(sid, target_item["fileId"], folder_name, folder_dest, force=force)
            folder_downloaded += dl
            folder_failed += fail
            folder_synced += 1
            log(f"  {progress} 完成: {folder_name} (下载{dl}, 失败{fail})")

        save_space_ids(space_ids)
        log(f"文件夹同步完成: 同步{folder_synced}, 下载{folder_downloaded}个文件, 失败{folder_failed}")

    # ===== 结果汇总 =====
    log("=" * 50)
    log("同步完成!")
    log(f"  新发现文件: {len(unique_new)}")
    log(f"  文件已下载: {downloaded}")
    log(f"  文件已过期: {expired}")
    log(f"  文件失败:   {failed}")
    log(f"  文件清单:   {len(manifest)}")
    if unique_new_images:
        log(f"  新发现媒体: {len(unique_new_images)}")
        log(f"  媒体已下载: {img_downloaded}")
        log(f"  媒体失败:   {img_failed}")
        log(f"  媒体无mediaId: {img_no_media}")
        log(f"  媒体清单:   {len(image_manifest)}")
    if unique_new_folders:
        log(f"  新发现文件夹: {len(unique_new_folders)}")
        log(f"  文件夹已同步: {folder_synced}")
        log(f"  文件夹内文件下载: {folder_downloaded}")
        log(f"  文件夹失败:   {folder_failed}")
    log("=" * 50)

    img_log = ""
    if unique_new_images:
        img_log = f", 媒体: 新{len(unique_new_images)}, 下载{img_downloaded}, 失败{img_failed}, 无mediaId{img_no_media}"
    folder_log = ""
    if unique_new_folders:
        folder_log = f", 文件夹: 新{len(unique_new_folders)}, 同步{folder_synced}, 下载{folder_downloaded}, 失败{folder_failed}"
    write_log(f"同步完成: 文件新{len(unique_new)}, 下载{downloaded}, 过期{expired}, 失败{failed}, 清单{len(manifest)}{img_log}{folder_log}")
    clear_checkpoint()
    return 0


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
    return load_json(CHAT_STATE_FILE, {})


def save_chat_state(state):
    save_json(CHAT_STATE_FILE, state)


def export_conversation_csv(conv_id, conv_title, start_time, csv_path):
    """导出单个会话的聊天记录到 CSV"""
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

    file_exists = csv_path.exists()
    csv_path.parent.mkdir(parents=True, exist_ok=True)
    with open(csv_path, "a", encoding="utf-8-sig", newline="") as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["时间", "发送人", "类型", "内容"])
        for m in all_messages:
            writer.writerow([m["time"], m["sender"], m["type"], m["content"]])

    return len(all_messages), all_messages[-1]["time"]


def run_export_csv(args):
    """执行聊天记录导出"""
    ensure_dirs()
    CHAT_EXPORT_DIR.mkdir(parents=True, exist_ok=True)

    convs = fetch_conversations_dynamic()
    if not convs:
        log("无法获取会话列表", "ERROR")
        return 1
    log(f"加载了 {len(convs)} 个会话")

    chat_state = load_chat_state()
    if args.full:
        start_time = "2020-01-01 00:00:00"
        log("导出模式: 全量")
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

        conv_start = start_time
        if not args.full and conv_id in chat_state:
            saved_time = chat_state[conv_id]
            if saved_time > conv_start:
                conv_start = saved_time

        csv_path = CHAT_EXPORT_DIR / f"{safe_title}.csv"

        if (i + 1) % 10 == 0 or i == 0 or i == len(convs) - 1:
            log(f"  [{i+1}/{len(convs)}] {conv_title}...")

        try:
            count, last_time = export_conversation_csv(conv_id, conv_title, conv_start, csv_path)
            if count > 0:
                total_msgs += count
                total_convs += 1
                chat_state[conv_id] = last_time
                log(f"  [{conv_title}] 导出 {count} 条消息")
        except Exception as e:
            log(f"  [{conv_title}] 导出出错: {e}", "ERROR")
            errors += 1

        if (i + 1) % 10 == 0:
            save_chat_state(chat_state)

    save_chat_state(chat_state)
    log("=" * 50)
    log(f"导出完成: {total_convs} 会话, {total_msgs} 消息, {errors} 错误")
    log("=" * 50)
    write_log(f"CSV导出完成: {total_convs} 会话, {total_msgs} 消息, {errors} 错误")
    return 0


# ============================================================
# 日程同步 (dws calendar)
# ============================================================

def fetch_calendar_events(start_iso, end_iso, limit=100, max_pages=50):
    """获取指定时间范围内的日程列表，自动翻页"""
    all_events = []
    cursor = ""
    page = 0
    while max_pages <= 0 or page < max_pages:
        page += 1
        cmd = ["calendar", "event", "list",
               "--start", start_iso, "--end", end_iso,
               "--limit", str(min(limit, 100)), "-y"]
        if cursor:
            cmd += ["--cursor", cursor]
        data = dws_call(cmd, timeout=30)
        if not data:
            break
        result = data.get("result", data)
        events = result.get("events", [])
        if not events:
            break
        all_events.extend(events)
        cursor = result.get("nextCursor", "")
        if not cursor or len(events) < limit:
            break
        time.sleep(REQUEST_INTERVAL)
    return all_events


def sync_calendar(days_back=7, days_forward=7, full=False):
    """
    同步日程到 CSV。
    增量模式：导出过去 days_back 天到未来 days_forward 天的日程。
    全量模式（full=True）：拉取全部日程（过去20年到未来10年的极宽窗口，不限页数）。
    """
    log("=" * 50)
    log("开始日程同步...")

    now = datetime.now().astimezone()
    # 使用本地时区偏移，不硬编码 +08:00
    utc_off = now.strftime("%z")  # e.g. "+0800"
    utc_off_fmt = utc_off[:3] + ":" + utc_off[3:]  # "+08:00"

    if full:
        # 全量模式: 钉钉日程接口单次查询时间跨度上限约 365 天（超出返回空），
        # 因此按 360 天分段抓取过去10年到未来2年的全部日程，按 id 去重合并。
        log("  模式: 全量 (分段拉取全部日程)")
        chunk_days = 360
        past_limit = now - timedelta(days=365 * 10)
        future_limit = now + timedelta(days=365 * 2)
        log(f"  时间范围: {past_limit.strftime('%Y-%m-%d')} ~ {future_limit.strftime('%Y-%m-%d')}")

        events = []
        seen_ids = set()
        seg_start = past_limit
        seg_index = 0
        while seg_start < future_limit:
            seg_end = seg_start + timedelta(days=chunk_days)
            if seg_end > future_limit:
                seg_end = future_limit
            seg_index += 1
            s_iso = seg_start.strftime(f"%Y-%m-%dT00:00:00{utc_off_fmt}")
            e_iso = seg_end.strftime(f"%Y-%m-%dT23:59:59{utc_off_fmt}")
            chunk = fetch_calendar_events(s_iso, e_iso, max_pages=0)
            new_count = 0
            for ev in chunk:
                eid = ev.get("id", "")
                if eid:
                    if eid in seen_ids:
                        continue
                    seen_ids.add(eid)
                events.append(ev)
                new_count += 1
            log(f"  分段{seg_index} {seg_start.strftime('%Y-%m-%d')}~{seg_end.strftime('%Y-%m-%d')}: "
                f"本段 {len(chunk)} 条, 新增 {new_count} 条")
            seg_start = seg_end + timedelta(days=1)
            time.sleep(REQUEST_INTERVAL)
    else:
        start_dt = now - timedelta(days=days_back)
        end_dt = now + timedelta(days=days_forward)
        start_iso = start_dt.strftime(f"%Y-%m-%dT00:00:00{utc_off_fmt}")
        end_iso = end_dt.strftime(f"%Y-%m-%dT23:59:59{utc_off_fmt}")
        log(f"  时间范围: {start_dt.strftime('%Y-%m-%d')} ~ {end_dt.strftime('%Y-%m-%d')}")
        events = fetch_calendar_events(start_iso, end_iso, max_pages=50)

    log(f"  获取到 {len(events)} 条日程")

    if not events:
        log("  无日程数据")
        return 0

    # 导出 CSV
    CALENDAR_EXPORT_DIR.mkdir(parents=True, exist_ok=True)
    ts = now.strftime("%Y%m%d_%H%M%S")
    csv_path = CALENDAR_EXPORT_DIR / f"calendar_{ts}.csv"

    fieldnames = [
        "id", "summary", "start_time", "end_time", "is_all_day",
        "organizer", "attendee_count", "attendees",
        "location", "meeting_room", "status", "free_busy",
        "online_meeting_type", "online_meeting_code",
        "description", "categories",
    ]

    rows = []
    for ev in events:
        start_info = ev.get("start", {})
        end_info = ev.get("end", {})
        start_time = start_info.get("dateTime") or start_info.get("date") or ""
        end_time = end_info.get("dateTime") or end_info.get("date") or ""

        organizer = ev.get("organizer", {}).get("displayName", "")
        attendees = ev.get("attendees", [])
        attendee_names = [a.get("displayName", "") for a in attendees if a.get("displayName")]

        rooms = ev.get("meetingRooms", [])
        room_names = [r.get("roomName", "") for r in rooms if r.get("roomName")]

        online = ev.get("onlineMeetingInfo", {})
        online_type = online.get("type", "")
        online_code = ""
        if online.get("extraInfo"):
            online_code = online["extraInfo"].get("roomCode", "")

        cats = ev.get("categories", [])
        cat_names = [c.get("displayName", "") for c in cats if c.get("displayName")]

        rows.append({
            "id": ev.get("id", ""),
            "summary": ev.get("summary", ""),
            "start_time": start_time,
            "end_time": end_time,
            "is_all_day": ev.get("isAllDay", False),
            "organizer": organizer,
            "attendee_count": len(attendees),
            "attendees": "; ".join(attendee_names),
            "location": ev.get("location") or "",
            "meeting_room": "; ".join(room_names),
            "status": ev.get("status", ""),
            "free_busy": ev.get("freeBusy", ""),
            "online_meeting_type": online_type,
            "online_meeting_code": online_code,
            "description": (ev.get("description") or "")[:500],
            "categories": "; ".join(cat_names),
        })

    # 按开始时间排序
    rows.sort(key=lambda r: r["start_time"])

    with open(csv_path, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    log(f"  已导出: {csv_path} ({len(rows)} 条)")

    # 同时保存一份 latest 副本
    latest_path = CALENDAR_EXPORT_DIR / "calendar_latest.csv"
    try:
        import shutil
        shutil.copy2(csv_path, latest_path)
    except Exception:
        pass

    # 保存状态
    state = {
        "last_sync": now.isoformat(),
        "days_back": days_back,
        "days_forward": days_forward,
        "events_count": len(rows),
        "csv_file": str(csv_path.name),
    }
    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        with open(CALENDAR_STATE_FILE, "w", encoding="utf-8") as f:
            json.dump(state, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

    write_log(f"日程同步完成: {len(rows)} 条日程 -> {csv_path.name}")
    return 0


# ============================================================
# 待办同步 (dws todo)
# ============================================================

def fetch_todo_tasks(status=None, page=1, size=20):
    """获取待办列表（API 最大 size=20）"""
    size = min(size, 20)
    cmd = ["todo", "+get-my-tasks", "--size", str(size), "--page", str(page), "-y"]
    if status is not None:
        cmd += ["--status", str(status).lower()]
    data = dws_call(cmd, timeout=30)
    if not data:
        return [], 0
    todos = data.get("todos", [])
    count = data.get("count", len(todos))
    return todos, count


def sync_todo():
    """
    同步待办到 CSV。
    分别获取未完成和已完成的待办。
    """
    log("=" * 50)
    log("开始待办同步...")

    all_todos = []

    # 获取未完成待办
    page = 1
    while True:
        todos, _ = fetch_todo_tasks(status=False, page=page, size=20)
        if not todos:
            break
        for t in todos:
            t["_status"] = "未完成"
        all_todos.extend(todos)
        log(f"  未完成待办: 第{page}页, 获取 {len(todos)} 条")
        if len(todos) < 20:
            break
        page += 1
        time.sleep(REQUEST_INTERVAL)

    # 获取已完成待办
    page = 1
    while True:
        todos, _ = fetch_todo_tasks(status=True, page=page, size=20)
        if not todos:
            break
        for t in todos:
            t["_status"] = "已完成"
        all_todos.extend(todos)
        log(f"  已完成待办: 第{page}页, 获取 {len(todos)} 条")
        if len(todos) < 20:
            break
        page += 1
        time.sleep(REQUEST_INTERVAL)

    log(f"  共获取 {len(all_todos)} 条待办")

    if not all_todos:
        log("  无待办数据")
        return 0

    # 导出 CSV
    TODO_EXPORT_DIR.mkdir(parents=True, exist_ok=True)
    now = datetime.now()
    ts = now.strftime("%Y%m%d_%H%M%S")
    csv_path = TODO_EXPORT_DIR / f"todo_{ts}.csv"

    priority_map = {10: "低", 20: "普通", 30: "紧急", 40: "非常紧急"}

    fieldnames = [
        "task_id", "subject", "status", "priority", "priority_label",
        "due_time", "created_time",
    ]

    rows = []
    for t in all_todos:
        due_ts = t.get("dueTime")
        due_str = ""
        if due_ts:
            try:
                due_str = datetime.fromtimestamp(due_ts / 1000).strftime("%Y-%m-%d %H:%M")
            except (ValueError, OSError, OverflowError):
                due_str = str(due_ts)

        priority = t.get("priority", 0)
        rows.append({
            "task_id": t.get("taskId", ""),
            "subject": t.get("subject", ""),
            "status": t.get("_status", ""),
            "priority": priority,
            "priority_label": priority_map.get(priority, str(priority)),
            "due_time": due_str,
            "created_time": "",  # API 未返回创建时间
        })

    with open(csv_path, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

    log(f"  已导出: {csv_path} ({len(rows)} 条)")

    # latest 副本
    latest_path = TODO_EXPORT_DIR / "todo_latest.csv"
    try:
        import shutil
        shutil.copy2(csv_path, latest_path)
    except Exception:
        pass

    # 保存状态
    state = {
        "last_sync": now.isoformat(),
        "total_count": len(rows),
        "csv_file": str(csv_path.name),
    }
    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        with open(TODO_STATE_FILE, "w", encoding="utf-8") as f:
            json.dump(state, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

    write_log(f"待办同步完成: {len(rows)} 条待办 -> {csv_path.name}")
    return 0


# ============================================================
# AI听记同步 (dws minutes)
# ============================================================

def fetch_minutes_list(limit=20, cursor=""):
    """获取听记列表"""
    cmd = ["minutes", "list", "all", "--limit", str(limit), "-y"]
    if cursor:
        cmd += ["--cursor", cursor]
    data = dws_call(cmd, timeout=30)
    if not data:
        return [], ""
    result = data.get("result", data)
    minutes = result.get("itemList", result.get("minutes", []))
    next_cursor = result.get("nextToken", "") or result.get("nextCursor", "")
    has_more = result.get("hasMore", False)
    if not has_more:
        next_cursor = ""
    return minutes, next_cursor


def fetch_minute_detail(task_uuid, artifacts="basic,summary,keywords,todos"):
    """获取单条听记详情（不含逐字稿以节省空间，需要时可加 transcript）"""
    cmd = ["minutes", "+detail", "--id", task_uuid,
           "--artifacts", artifacts, "-y"]
    data = dws_call(cmd, timeout=60)
    return data


def sync_minutes(include_transcript=False):
    """
    同步AI听记到本地。
    导出摘要、关键词、待办到 JSON，可选包含逐字稿。
    """
    log("=" * 50)
    log("开始AI听记同步...")

    all_minutes = []
    cursor = ""
    page = 0
    while True:
        page += 1
        minutes, next_cursor = fetch_minutes_list(limit=20, cursor=cursor)
        if not minutes:
            break
        all_minutes.extend(minutes)
        log(f"  听记列表: 第{page}页, 获取 {len(minutes)} 条")
        cursor = next_cursor
        if not cursor:
            break
        time.sleep(REQUEST_INTERVAL)

    log(f"  共获取 {len(all_minutes)} 条听记")

    if not all_minutes:
        log("  无听记数据")
        return 0

    # 加载已有状态，跳过已同步的
    prev_synced = set()
    try:
        if MINUTES_STATE_FILE.exists():
            prev = json.loads(MINUTES_STATE_FILE.read_text(encoding="utf-8"))
            prev_synced = set(prev.get("synced_ids", []))
    except Exception:
        pass

    MINUTES_EXPORT_DIR.mkdir(parents=True, exist_ok=True)
    now = datetime.now()
    ts = now.strftime("%Y%m%d_%H%M%S")

    artifacts = "basic,summary,keywords,todos"
    if include_transcript:
        artifacts += ",transcript"

    synced_count = 0
    skipped_count = 0
    error_count = 0
    synced_ids = list(prev_synced)
    summary_rows = []

    for m in all_minutes:
        task_uuid = m.get("uuid", m.get("taskUuid", m.get("id", "")))
        title = m.get("title", m.get("name", "未命名听记"))

        if task_uuid in prev_synced:
            skipped_count += 1
            continue

        log(f"  获取详情: {title[:30]}...")
        detail = fetch_minute_detail(task_uuid, artifacts=artifacts)
        if not detail:
            error_count += 1
            log(f"    获取失败", "WARN")
            continue

        # 保存单条听记 JSON
        safe_title = safe_filename(title)[:50]
        json_path = MINUTES_EXPORT_DIR / f"{safe_title}_{task_uuid[:8]}.json"
        try:
            with open(json_path, "w", encoding="utf-8") as f:
                json.dump(detail, f, ensure_ascii=False, indent=2)
        except Exception as e:
            error_count += 1
            log(f"    保存失败: {e}", "WARN")
            continue

        # 如果有逐字稿，额外保存为 txt
        if include_transcript:
            transcript = detail.get("transcript", {})
            if isinstance(transcript, dict):
                paragraphs = transcript.get("paragraphs", [])
            elif isinstance(transcript, list):
                paragraphs = transcript
            else:
                paragraphs = []
            if paragraphs:
                txt_path = MINUTES_EXPORT_DIR / f"{safe_title}_{task_uuid[:8]}_transcript.txt"
                try:
                    with open(txt_path, "w", encoding="utf-8") as f:
                        for p in paragraphs:
                            speaker = p.get("speakerName", p.get("speaker", ""))
                            text = p.get("text", p.get("content", ""))
                            if speaker:
                                f.write(f"[{speaker}] {text}\n")
                            else:
                                f.write(f"{text}\n")
                except Exception:
                    pass

        # 摘要信息用于汇总表
        basic = detail.get("basic", {})
        summary_data = detail.get("summary", {})
        summary_text = ""
        if isinstance(summary_data, dict):
            summary_text = summary_data.get("text", summary_data.get("content", ""))
        elif isinstance(summary_data, str):
            summary_text = summary_data

        keywords = detail.get("keywords", [])
        if isinstance(keywords, dict):
            keywords = keywords.get("keywords", [])
        kw_str = ", ".join(keywords) if isinstance(keywords, list) else str(keywords)

        summary_rows.append({
            "task_uuid": task_uuid,
            "title": title,
            "summary": summary_text[:300] if summary_text else "",
            "keywords": kw_str,
            "file": json_path.name,
        })

        synced_count += 1
        synced_ids.append(task_uuid)
        time.sleep(REQUEST_INTERVAL)

    # 导出汇总表 CSV
    if summary_rows:
        csv_path = MINUTES_EXPORT_DIR / f"minutes_summary_{ts}.csv"
        fieldnames = ["task_uuid", "title", "summary", "keywords", "file"]
        with open(csv_path, "w", encoding="utf-8-sig", newline="") as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(summary_rows)
        log(f"  汇总表: {csv_path}")

        latest_path = MINUTES_EXPORT_DIR / "minutes_summary_latest.csv"
        try:
            shutil.copy2(csv_path, latest_path)
        except Exception:
            pass

    log(f"  新增 {synced_count} 条, 跳过 {skipped_count} 条(已同步), 失败 {error_count} 条")

    # 保存状态
    state = {
        "last_sync": now.isoformat(),
        "total_minutes": len(all_minutes),
        "synced_count": synced_count,
        "skipped_count": skipped_count,
        "error_count": error_count,
        "synced_ids": synced_ids,
    }
    try:
        STATE_DIR.mkdir(parents=True, exist_ok=True)
        with open(MINUTES_STATE_FILE, "w", encoding="utf-8") as f:
            json.dump(state, f, ensure_ascii=False, indent=2)
    except Exception:
        pass

    write_log(f"听记同步完成: 新增{synced_count}, 跳过{skipped_count}, 失败{error_count}")
    return 0


# ============================================================
# 通讯录同步
# ============================================================

def fetch_dept_children(dept_id):
    """获取指定部门的子部门列表，返回 [{deptId, deptName}, ...]"""
    data = dws_call(["contact", "dept", "list-children", "--dept", str(dept_id),
                     "--format", "json", "-y"], timeout=30)
    if not data or data.get("_error"):
        return []
    result = data.get("result", data.get("deptList", []))
    if isinstance(result, list):
        return result
    return []


def fetch_dept_members(dept_id):
    """获取指定部门的成员列表，返回 [{name, userId}, ...]"""
    data = dws_call(["contact", "dept", "list-members", "--depts", str(dept_id),
                     "--format", "json", "-y"], timeout=30)
    if not data or data.get("_error"):
        return []
    members = []
    dept_user_list = data.get("deptUserList", [])
    if isinstance(dept_user_list, list):
        for item in dept_user_list:
            user_info = item.get("userInfo", item)
            if isinstance(user_info, dict):
                uid = user_info.get("userId", user_info.get("userid", ""))
                name = user_info.get("name", user_info.get("userName", ""))
                if uid:
                    members.append({"userId": uid, "name": name})
    return members


def fetch_user_detail(user_id):
    """获取用户详细信息，返回 orgEmployeeModel dict 或 None"""
    data = dws_call(["contact", "user", "get", "--user-id", str(user_id),
                     "--format", "json", "-y"], timeout=30)
    if not data or data.get("_error"):
        return None
    result = data.get("result", [])
    if isinstance(result, list) and result:
        entry = result[0]
        model = entry.get("orgEmployeeModel", entry)
        model["_isAdmin"] = entry.get("isAdmin", False)
        return model
    if isinstance(result, dict):
        model = result.get("orgEmployeeModel", result)
        model["_isAdmin"] = result.get("isAdmin", False)
        return model
    return None


def sync_contacts():
    """
    同步全公司通讯录到本地 CSV。
    BFS 遍历部门树，收集所有成员，获取详情后导出。
    """
    log("=" * 50)
    log("开始通讯录同步...")
    log("  模式: 全公司")

    # BFS 遍历部门树
    log("  遍历部门树...")
    from collections import deque
    dept_queue = deque([1])  # 根部门 ID = 1
    dept_visited = set()
    dept_map = {1: "根部门"}  # deptId -> deptName
    all_members = {}  # userId -> {name, dept_ids: set()}
    dept_count = 0

    while dept_queue:
        if is_cancelled():
            log("  用户取消", "WARN")
            return 1

        dept_id = dept_queue.popleft()
        if dept_id in dept_visited:
            continue
        dept_visited.add(dept_id)
        dept_count += 1

        # 获取子部门
        children = fetch_dept_children(dept_id)
        for child in children:
            cid = child.get("deptId", child.get("id", 0))
            cname = child.get("deptName", child.get("name", ""))
            if cid and cid not in dept_visited:
                dept_map[cid] = cname
                dept_queue.append(cid)
        time.sleep(REQUEST_INTERVAL)

        # 获取部门成员
        members = fetch_dept_members(dept_id)
        for m in members:
            uid = m["userId"]
            if uid in all_members:
                all_members[uid]["dept_ids"].add(dept_id)
            else:
                all_members[uid] = {"name": m["name"], "dept_ids": {dept_id}}
        time.sleep(REQUEST_INTERVAL)

        if dept_count % 10 == 0:
            log(f"  已遍历 {dept_count} 个部门, 发现 {len(all_members)} 位成员")

    log(f"  部门遍历完成: {dept_count} 个部门, {len(all_members)} 位成员")

    if not all_members:
        log("  无成员数据")
        return 0

    # 获取每位成员的详细信息
    log(f"  获取 {len(all_members)} 位成员详情...")
    detail_rows = []
    fetched = 0
    detail_errors = 0

    for uid, info in all_members.items():
        if is_cancelled():
            log("  用户取消", "WARN")
            return 1

        fetched += 1
        model = fetch_user_detail(uid)
        time.sleep(REQUEST_INTERVAL)

        if not model:
            detail_errors += 1
            # 使用基础信息兜底
            dept_names = [dept_map.get(d, str(d)) for d in info["dept_ids"]]
            detail_rows.append({
                "userId": uid,
                "name": info["name"],
                "jobNumber": "",
                "title": "",
                "email": "",
                "mobile": "",
                "departments": " / ".join(dept_names),
                "orgName": "",
                "isAdmin": "",
            })
            continue

        # 解析部门名称
        depts_raw = model.get("depts", [])
        if isinstance(depts_raw, list):
            dept_names = []
            for d in depts_raw:
                if isinstance(d, dict):
                    dept_names.append(d.get("deptName", d.get("name", str(d.get("deptId", "")))))
                else:
                    dept_names.append(str(d))
        else:
            dept_names = [dept_map.get(d, str(d)) for d in info["dept_ids"]]

        if not dept_names:
            dept_names = [dept_map.get(d, str(d)) for d in info["dept_ids"]]

        detail_rows.append({
            "userId": model.get("orgUserId", uid),
            "name": model.get("orgUserName", info["name"]),
            "jobNumber": model.get("jobNumber", ""),
            "title": model.get("orgTitle", ""),
            "email": model.get("orgAuthEmail", ""),
            "mobile": model.get("mobile", ""),
            "departments": " / ".join(dept_names),
            "orgName": model.get("orgName", ""),
            "isAdmin": "是" if model.get("_isAdmin") else "",
        })

        if fetched % 50 == 0:
            log(f"  已获取 {fetched}/{len(all_members)} 位成员详情")

    log(f"  详情获取完成: 成功 {fetched - detail_errors}, 失败 {detail_errors}")

    # 导出 CSV
    CONTACTS_EXPORT_DIR.mkdir(parents=True, exist_ok=True)
    now = datetime.now()
    ts = now.strftime("%Y%m%d_%H%M%S")
    csv_path = CONTACTS_EXPORT_DIR / f"contacts_{ts}.csv"

    fieldnames = ["userId", "name", "jobNumber", "title", "email", "mobile",
                  "departments", "orgName", "isAdmin"]
    with open(csv_path, "w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(detail_rows)

    # 同时保存一份 latest 副本
    latest_path = CONTACTS_EXPORT_DIR / "contacts_latest.csv"
    try:
        shutil.copy2(csv_path, latest_path)
    except Exception:
        pass

    log(f"  导出: {csv_path} ({len(detail_rows)} 条)")

    # 保存状态
    state = {
        "last_sync": now.isoformat(),
        "total_count": len(detail_rows),
        "dept_count": dept_count,
        "detail_errors": detail_errors,
        "csv_file": str(csv_path),
    }
    try:
        save_json(CONTACTS_STATE_FILE, state)
    except Exception:
        pass

    write_log(f"通讯录同步完成: {len(detail_rows)}人, {dept_count}部门, 失败{detail_errors}")
    return 0


# ============================================================
# 数据量估算 & 磁盘空间检查
# ============================================================

def check_disk_space(path):
    """
    检查指定路径所在磁盘的空间使用情况。
    返回 dict: {total, used, free, total_str, used_str, free_str, path}
    供 Qt 界面和 CLI 共用。
    """
    path = str(path)
    try:
        usage = shutil.disk_usage(path)
        return {
            "path": path,
            "total": usage.total,
            "used": usage.used,
            "free": usage.free,
            "total_str": format_size(usage.total),
            "used_str": format_size(usage.used),
            "free_str": format_size(usage.free),
            "ok": True,
        }
    except Exception as e:
        return {
            "path": path,
            "total": 0, "used": 0, "free": 0,
            "total_str": "?", "used_str": "?", "free_str": "?",
            "ok": False,
            "error": str(e),
        }


def _calc_avg_file_size(manifest_records):
    """从已下载记录的 _localPath 统计平均文件大小（字节）"""
    sizes = []
    for rec in manifest_records:
        if not rec.get("_downloaded"):
            continue
        local_path = rec.get("_localPath", "")
        if not local_path:
            continue
        try:
            sz = os.path.getsize(local_path)
            if sz > 0:
                sizes.append(sz)
        except OSError:
            continue
    if not sizes:
        return 0, 0
    return sum(sizes) // len(sizes), len(sizes)


def estimate_sync_size(days=30, use_bulk=True):
    """
    估算同步所需磁盘空间。

    通过 list-all 批量扫描（或逐会话回退）统计时间范围内的文件/图片/视频/文件夹数量，
    结合已下载文件的平均大小，预估尚未下载的内容所需空间。

    参数:
        days: 扫描最近多少天的消息（默认 30）
        use_bulk: 是否优先使用 list-all 批量模式

    返回 dict:
        {
            "scan_days": int,
            "total_messages": int,
            "file_count": int,        # 文件消息总数
            "image_count": int,       # 图片消息总数
            "video_count": int,       # 视频消息总数
            "folder_count": int,      # 文件夹消息总数
            "file_downloaded": int,   # 已下载文件数
            "image_downloaded": int,  # 已下载媒体数
            "file_pending": int,      # 待下载文件数
            "image_pending": int,     # 待下载媒体数
            "avg_file_size": int,     # 平均文件大小(字节)
            "avg_image_size": int,    # 平均媒体大小(字节)
            "avg_file_sample": int,   # 文件样本数
            "avg_image_sample": int,  # 媒体样本数
            "est_file_bytes": int,    # 预估文件所需空间
            "est_image_bytes": int,   # 预估媒体所需空间
            "est_folder_bytes": int,  # 预估文件夹所需空间（按文件估算）
            "est_total_bytes": int,   # 预估总空间
            "est_total_str": str,     # 格式化后的总空间
            "scan_method": str,       # "bulk" | "per_conv" | "manifest_only"
            "conversations": int,     # 涉及的会话数
        }
    """
    now = datetime.now()
    start_dt = now - timedelta(days=days)
    start_time = start_dt.strftime("%Y-%m-%d %H:%M:%S")
    end_time = now.strftime("%Y-%m-%d %H:%M:%S")

    log(f"数据量估算: 扫描最近 {days} 天 ({start_time} ~ {end_time})")

    # 加载已有清单（用于去重和计算平均大小）
    manifest = load_manifest()
    image_manifest = load_image_manifest()

    file_downloaded = sum(1 for r in manifest.values() if r.get("_downloaded"))
    image_downloaded = sum(1 for r in image_manifest.values() if r.get("_downloaded"))

    avg_file_size, avg_file_sample = _calc_avg_file_size(list(manifest.values()))
    avg_image_size, avg_image_sample = _calc_avg_file_size(list(image_manifest.values()))

    # 默认估算值（无样本时的经验值）
    DEFAULT_AVG_FILE_SIZE = 2 * 1024 * 1024    # 2 MB
    DEFAULT_AVG_IMAGE_SIZE = 500 * 1024         # 500 KB
    DEFAULT_AVG_FOLDER_SIZE = 10 * 1024 * 1024  # 10 MB（文件夹按含若干文件估）

    if avg_file_size == 0:
        avg_file_size = DEFAULT_AVG_FILE_SIZE
    if avg_image_size == 0:
        avg_image_size = DEFAULT_AVG_IMAGE_SIZE

    # 尝试扫描消息
    file_count = 0
    image_count = 0
    video_count = 0
    folder_count = 0
    total_messages = 0
    conversations = 0
    scan_method = "manifest_only"

    # 已知的 fileId / mediaId（用于去重）
    known_file_ids = set(manifest.keys())
    known_media_ids = set(k for k in image_manifest.keys() if k)

    new_file_ids = set()
    new_media_ids = set()

    if use_bulk:
        bulk_ret = fetch_messages_bulk(start_time, end_time, limit=50, max_pages=100)
        conv_map = bulk_ret[0] if isinstance(bulk_ret, tuple) else bulk_ret
        if conv_map is not None:
            scan_method = "bulk"
            conversations = len(conv_map)
            for conv_id, conv_data in conv_map.items():
                messages = conv_data["messages"]
                total_messages += len(messages)

                for fm in extract_file_messages(messages):
                    fid = fm["fileId"]
                    file_count += 1
                    if fid not in known_file_ids:
                        new_file_ids.add(fid)

                for im in extract_media_messages(messages):
                    mid = im.get("mediaId", "")
                    if im.get("_noMediaId"):
                        continue  # 无 mediaId 的无法下载，不计入
                    if im["mediaType"] == "video":
                        video_count += 1
                    else:
                        image_count += 1
                    if mid and mid not in known_media_ids:
                        new_media_ids.add(mid)

                for _ in extract_folder_messages(messages):
                    folder_count += 1
        else:
            log("  list-all 不可用，回退到逐会话扫描", "WARN")

    if scan_method == "manifest_only":
        # 回退: 逐会话扫描
        convs = load_json(CONVS_FILE)
        if convs:
            scan_method = "per_conv"
            conversations = len(convs)
            space_ids_cache = load_space_ids()
            for conv in convs:
                conv_id = conv.get("convId", "")
                conv_title = conv.get("title", "")
                if not conv_id:
                    continue
                try:
                    files_f, images_f, folders_f = scan_conversation(
                        conv_id, conv_title, start_time, space_ids_cache)
                    total_messages += len(files_f) + len(images_f) + len(folders_f)
                    for fm in files_f:
                        file_count += 1
                        fid = fm.get("fileId", "")
                        if fid and fid not in known_file_ids:
                            new_file_ids.add(fid)
                    for im in images_f:
                        mid = im.get("mediaId", "")
                        if im.get("_noMediaId"):
                            continue
                        if im.get("mediaType") == "video":
                            video_count += 1
                        else:
                            image_count += 1
                        if mid and mid not in known_media_ids:
                            new_media_ids.add(mid)
                    folder_count += len(folders_f)
                except Exception:
                    continue
                time.sleep(REQUEST_INTERVAL)
        else:
            # 无会话数据，仅用清单估算
            log("  无会话数据，仅基于已有清单估算", "WARN")

    # 待下载数量 = 新发现的（不在已有清单中的）
    file_pending = len(new_file_ids) if scan_method != "manifest_only" else 0
    image_pending = len(new_media_ids) if scan_method != "manifest_only" else 0

    # 如果完全无法扫描，用清单中未下载的作为待处理
    if scan_method == "manifest_only":
        file_pending = sum(1 for r in manifest.values()
                          if not r.get("_downloaded") and not r.get("_expired"))
        image_pending = sum(1 for r in image_manifest.values()
                          if not r.get("_downloaded") and not r.get("_noMediaId"))

    # 估算空间
    est_file_bytes = file_pending * avg_file_size
    est_image_bytes = image_pending * avg_image_size
    est_folder_bytes = folder_count * DEFAULT_AVG_FOLDER_SIZE if folder_count else 0
    est_total_bytes = est_file_bytes + est_image_bytes + est_folder_bytes

    result = {
        "scan_days": days,
        "total_messages": total_messages,
        "file_count": file_count,
        "image_count": image_count,
        "video_count": video_count,
        "folder_count": folder_count,
        "file_downloaded": file_downloaded,
        "image_downloaded": image_downloaded,
        "file_pending": file_pending,
        "image_pending": image_pending,
        "avg_file_size": avg_file_size,
        "avg_image_size": avg_image_size,
        "avg_file_sample": avg_file_sample,
        "avg_image_sample": avg_image_sample,
        "est_file_bytes": est_file_bytes,
        "est_image_bytes": est_image_bytes,
        "est_folder_bytes": est_folder_bytes,
        "est_total_bytes": est_total_bytes,
        "est_total_str": format_size(est_total_bytes),
        "scan_method": scan_method,
        "conversations": conversations,
    }

    log(f"  估算完成: 文件{file_count}(待下载{file_pending}), "
        f"图片{image_count}+视频{video_count}(待下载{image_pending}), "
        f"文件夹{folder_count}, 预估 {format_size(est_total_bytes)}")

    return result


def run_estimate(args):
    """CLI: 运行数据量估算并显示报告"""
    ensure_dirs()
    days = getattr(args, 'estimate_days', 30) or 30
    use_bulk = not getattr(args, 'no_bulk', False)

    print()
    print("=" * 55)
    print(f"  钉钉同步 - 数据量估算 (最近 {days} 天)")
    print("=" * 55)

    # 认证检查
    status = check_auth_status()
    if not status.get("token_valid"):
        if status.get("refresh_token_valid"):
            print("  Token 已过期，尝试自动刷新...")
            ok, msg = try_auth_refresh()
            if not ok:
                print(f"  [ERROR] 刷新失败: {msg}")
                print("  请运行 --login 重新扫码登录")
                return 1
        else:
            print("  [ERROR] 未认证，请先运行 --login 扫码登录")
            return 1

    est = estimate_sync_size(days=days, use_bulk=use_bulk)

    print()
    print(f"  扫描方式:     {est['scan_method']}")
    print(f"  涉及会话:     {est['conversations']} 个")
    print(f"  扫描消息:     {est['total_messages']} 条")
    print()
    print("  --- 数据统计 ---")
    print(f"  文件消息:     {est['file_count']} 个 (已下载 {est['file_downloaded']}, 待下载 {est['file_pending']})")
    print(f"  图片消息:     {est['image_count']} 个")
    print(f"  视频消息:     {est['video_count']} 个")
    print(f"  媒体合计:     {est['image_count'] + est['video_count']} 个 (已下载 {est['image_downloaded']}, 待下载 {est['image_pending']})")
    print(f"  文件夹分享:   {est['folder_count']} 个")
    print()
    print("  --- 空间估算 ---")
    if est['avg_file_sample'] > 0:
        print(f"  文件平均大小: {format_size(est['avg_file_size'])} (基于 {est['avg_file_sample']} 个样本)")
    else:
        print(f"  文件平均大小: {format_size(est['avg_file_size'])} (经验值，无下载样本)")
    if est['avg_image_sample'] > 0:
        print(f"  媒体平均大小: {format_size(est['avg_image_size'])} (基于 {est['avg_image_sample']} 个样本)")
    else:
        print(f"  媒体平均大小: {format_size(est['avg_image_size'])} (经验值，无下载样本)")
    print(f"  文件预估:     {format_size(est['est_file_bytes'])}")
    print(f"  媒体预估:     {format_size(est['est_image_bytes'])}")
    if est['est_folder_bytes'] > 0:
        print(f"  文件夹预估:   {format_size(est['est_folder_bytes'])}")
    print(f"  总计预估:     {est['est_total_str']}")

    # 磁盘空间检查
    check_path = getattr(args, 'check_space', '') or str(BASE_DIR)
    disk = check_disk_space(check_path)

    print()
    print("  --- 磁盘空间 ---")
    if disk["ok"]:
        print(f"  目标路径:     {disk['path']}")
        print(f"  磁盘总容量:   {disk['total_str']}")
        print(f"  已使用:       {disk['used_str']}")
        print(f"  可用空间:     {disk['free_str']}")
        print()
        if est['est_total_bytes'] > 0:
            ratio = est['est_total_bytes'] / disk['free'] if disk['free'] > 0 else float('inf')
            if ratio > 1.0:
                print(f"  [!] 警告: 预估所需空间 ({est['est_total_str']}) 超过可用空间 ({disk['free_str']})!")
                print(f"      空间不足，建议更换同步目录或减少同步天数。")
            elif ratio > 0.8:
                print(f"  [!] 注意: 预估所需空间占可用空间的 {ratio*100:.0f}%，空间较紧张。")
            else:
                print(f"  空间充足 (预估占可用空间的 {ratio*100:.1f}%)")
    else:
        print(f"  [ERROR] 无法检查路径: {disk['path']}")
        print(f"          {disk.get('error', '未知错误')}")

    print()
    print("=" * 55)
    return 0


# ============================================================
# 状态查看
# ============================================================

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

    img_total = len(image_manifest)
    img_downloaded = sum(1 for r in image_manifest.values() if r.get("_downloaded"))
    img_pending = sum(1 for r in image_manifest.values() if r.get("_pending"))
    img_no_media = sum(1 for r in image_manifest.values() if r.get("_noMediaId"))

    disk_files = 0
    disk_size = 0
    for root, dirs, files in os.walk(BASE_DIR):
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
    print(f"  钉钉同步状态 (Standalone v{__version__})")
    print("=" * 50)
    print(f"  会话数:     {len(convs) if convs else 0}")
    print(f"  清单文件数: {total}")
    print(f"  已下载:     {downloaded}")
    print(f"  已过期:     {expired}")
    print(f"  失败:       {failed}")
    print(f"  待处理:     {pending}")
    print(f"  媒体清单:   {img_total}")
    print(f"  媒体已下载: {img_downloaded}")
    print(f"  媒体待处理: {img_pending}")
    print(f"  媒体无mediaId: {img_no_media}")
    print(f"  磁盘文件:   {disk_files} ({format_size(disk_size)})")
    print(f"  同步目录:   {BASE_DIR}")

    # 日程/待办/听记 同步状态
    for label, state_file, export_dir in [
        ("日程", CALENDAR_STATE_FILE, CALENDAR_EXPORT_DIR),
        ("待办", TODO_STATE_FILE, TODO_EXPORT_DIR),
        ("听记", MINUTES_STATE_FILE, MINUTES_EXPORT_DIR),
    ]:
        if state_file.exists():
            try:
                st = json.loads(state_file.read_text(encoding="utf-8"))
                last = st.get("last_sync", "?")[:19]
                cnt = st.get("events_count", st.get("total_count", st.get("total_minutes", "?")))
                print(f"  {label}同步:   {cnt} 条 (上次: {last})")
            except Exception:
                print(f"  {label}同步:   状态读取失败")
        else:
            print(f"  {label}同步:   未执行")

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

    if SYNC_LOG_FILE.exists():
        lines = SYNC_LOG_FILE.read_text(encoding="utf-8").strip().split("\n")
        if lines:
            print()
            print("最近日志:")
            for line in lines[-5:]:
                print(f"  {line}")
    print()


# ============================================================
# 计划任务管理
# ============================================================

def setup_task(args):
    """安装 Windows 计划任务"""
    if sys.platform != "win32":
        log("计划任务安装仅支持 Windows", "ERROR")
        return 1

    script_path = str(Path(__file__).resolve())
    python_path = sys.executable
    task_name = "DingTalkSync"
    run_time = "21:00"
    run_days = 7

    config = load_config()
    if config:
        task_conf = config.get("task", {})
        run_time = task_conf.get("run_time", "21:00")
        run_days = task_conf.get("run_days", 7)

    # 生成 run_sync.bat（UTF-8 BOM 编码，配合 chcp 65001）
    bat_path = BASE_DIR / "run_sync.bat"
    try:
        run_days = int(run_days)
    except (ValueError, TypeError):
        run_days = 7
    bat_content = f'''@echo off
chcp 65001 >nul 2>&1
cd /d "{BASE_DIR}"
echo [%date% %time%] 开始同步...
"{python_path}" "{script_path}" --all --days {run_days}
echo [%date% %time%] 同步结束
'''
    with open(bat_path, "w", encoding="utf-8-sig") as f:
        f.write(bat_content)
    log(f"已生成启动器: {bat_path}")

    # 创建每日计划任务
    log(f"正在创建计划任务: {task_name}")
    log(f"  运行时间: 每天 {run_time}")
    log(f"  同步天数: {run_days} 天")

    # 删除旧任务（如果存在）
    subprocess.run(
        ["schtasks", "/Delete", "/TN", task_name, "/F"],
        capture_output=True, timeout=10,
        creationflags=_CREATE_NO_WINDOW
    )

    # 创建新任务
    cmd = [
        "schtasks", "/Create",
        "/TN", task_name,
        "/TR", f'"{bat_path}"',
        "/SC", "DAILY",
        "/ST", run_time,
        "/F"
    ]
    result = subprocess.run(cmd, capture_output=True, timeout=15,
                            creationflags=_CREATE_NO_WINDOW)
    if result.returncode == 0:
        log(f"计划任务已创建: 每天 {run_time} 运行")
    else:
        err = result.stderr.decode("utf-8", errors="replace").strip()
        log(f"创建计划任务失败: {err}", "ERROR")
        return 1

    # 创建开机启动任务（延迟5分钟）
    boot_task = f"{task_name}_Boot"
    subprocess.run(
        ["schtasks", "/Delete", "/TN", boot_task, "/F"],
        capture_output=True, timeout=10,
        creationflags=_CREATE_NO_WINDOW
    )
    cmd_boot = [
        "schtasks", "/Create",
        "/TN", boot_task,
        "/TR", f'"{bat_path}"',
        "/SC", "ONLOGON",
        "/DELAY", "0005:00",
        "/F"
    ]
    result_boot = subprocess.run(cmd_boot, capture_output=True, timeout=15,
                                 creationflags=_CREATE_NO_WINDOW)
    if result_boot.returncode == 0:
        log(f"开机任务已创建: 登录后延迟 5 分钟运行")
    else:
        err = result_boot.stderr.decode("utf-8", errors="replace").strip()
        log(f"开机任务创建失败（非致命）: {err}", "WARN")

    log("")
    log("计划任务安装完成!")
    log(f"  查看任务: schtasks /Query /TN {task_name}")
    log(f"  手动运行: schtasks /Run /TN {task_name}")
    log(f"  删除任务: python dingtalk_sync.py --remove-task")
    return 0


def remove_task(args):
    """卸载 Windows 计划任务"""
    if sys.platform != "win32":
        log("仅支持 Windows", "ERROR")
        return 1

    for task_name in ["DingTalkSync", "DingTalkSync_Boot"]:
        result = subprocess.run(
            ["schtasks", "/Delete", "/TN", task_name, "/F"],
            capture_output=True, timeout=10,
            creationflags=_CREATE_NO_WINDOW
        )
        if result.returncode == 0:
            log(f"已删除计划任务: {task_name}")
        else:
            log(f"计划任务不存在或已删除: {task_name}")

    bat_path = BASE_DIR / "run_sync.bat"
    if bat_path.exists():
        try:
            bat_path.unlink()
            log(f"已删除启动器: {bat_path}")
        except Exception:
            pass

    log("计划任务已完全卸载")
    return 0


# ============================================================
# 入口
# ============================================================

def main():
    if sys.platform == "win32":
        try:
            sys.stdout.reconfigure(encoding="utf-8")
            sys.stderr.reconfigure(encoding="utf-8")
        except Exception:
            pass

    parser = argparse.ArgumentParser(
        description=f"钉钉同步工具 v{__version__} (Standalone) - 文件/媒体/文件夹下载 + 聊天记录导出",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  python dingtalk_sync.py              增量同步（最近7天）
  python dingtalk_sync.py --all        文件同步 + 聊天记录导出
  python dingtalk_sync.py --full       全量扫描
  python dingtalk_sync.py --days 30    扫描最近30天
  python dingtalk_sync.py --retry-files  重试失败/未下载的文件
  python dingtalk_sync.py --retry-images 重试失败的图片/视频
  python dingtalk_sync.py --status     查看同步状态
  python dingtalk_sync.py --login      重新扫码登录
  python dingtalk_sync.py --sync-calendar  同步日程到 CSV
  python dingtalk_sync.py --sync-todo      同步待办到 CSV
  python dingtalk_sync.py --sync-minutes   同步AI听记到本地
  python dingtalk_sync.py --sync-all-new   同步日程+待办+听记
  python dingtalk_sync.py --estimate     估算数据量和磁盘空间
  python dingtalk_sync.py --estimate --estimate-days 90  估算最近90天
  python dingtalk_sync.py --setup-task 安装 Windows 计划任务
  python dingtalk_sync.py --remove-task  卸载计划任务
  python dingtalk_sync.py --init       首次运行，生成配置文件
        """
    )

    parser.add_argument("--init", action="store_true", help="生成配置文件（首次运行）")
    parser.add_argument("--full", action="store_true", help="全量扫描")
    parser.add_argument("--days", type=int, default=None, help="增量扫描天数（默认7天）")
    parser.add_argument("--scan-only", action="store_true", help="仅扫描，不下载")
    parser.add_argument("--no-bulk", action="store_true", help="禁用 list-all 批量扫描，使用逐会话模式")
    parser.add_argument("--dry-run", action="store_true", help="预览模式")
    parser.add_argument("--export-csv", action="store_true", help="导出聊天记录到 CSV")
    parser.add_argument("--all", action="store_true", help="文件同步 + 聊天记录导出")
    parser.add_argument("--force", action="store_true", help="强制覆盖: 重新下载已同步的文件和媒体")
    parser.add_argument("--status", action="store_true", help="显示同步状态")
    parser.add_argument("--check-auth", action="store_true", help="仅检查认证状态")
    parser.add_argument("--login", action="store_true", help="重新扫码登录（dws auth login）")
    parser.add_argument("--dingtalk-token", type=str, default="", help="钉钉 access_token")
    parser.add_argument("--retry-images", action="store_true", help="重试失败的图片")
    parser.add_argument("--retry-files", action="store_true", help="重试失败/未下载的文件")
    parser.add_argument("--setup-task", action="store_true", help="安装 Windows 计划任务")
    parser.add_argument("--remove-task", action="store_true", help="卸载 Windows 计划任务")
    parser.add_argument("--sync-calendar", action="store_true", help="同步日程到 CSV")
    parser.add_argument("--sync-todo", action="store_true", help="同步待办到 CSV")
    parser.add_argument("--sync-minutes", action="store_true", help="同步AI听记到本地")
    parser.add_argument("--sync-all-new", action="store_true", help="同步日程+待办+听记")
    parser.add_argument("--calendar-days", type=int, default=7, help="日程同步前后天数（默认7）")
    parser.add_argument("--with-transcript", action="store_true", help="听记同步包含逐字稿")
    parser.add_argument("--estimate", action="store_true", help="估算数据量和所需磁盘空间")
    parser.add_argument("--estimate-days", type=int, default=30, help="估算扫描天数（默认30）")
    parser.add_argument("--check-space", type=str, default="", help="检查指定路径的磁盘空间")

    args = parser.parse_args()

    if args.init:
        ok = init_config()
        return 0 if ok else 1

    config = load_config()
    if config is None:
        print(f"提示: 未找到配置文件 {CONFIG_FILE}")
        print("运行 python dingtalk_sync.py --init 生成配置文件")
        print("将使用默认配置继续运行...")
        print()

    if config:
        ok, err = apply_config(config)
        if not ok:
            print(f"[ERROR] 配置加载失败: {err}", file=sys.stderr)
            return 1

    dws_config_path = ""
    if config:
        dws_config_path = config.get("paths", {}).get("dws_core", "")

    if not find_dws_core(dws_config_path):
        return 1

    # 自动补全账号信息
    acct_name = ""
    if config:
        acct_name = config.get("account", {}).get("name", "")

    if not acct_name:
        info = detect_account_info()
        acct_name = info["name"]
        if acct_name:
            log(f"自动检测到账号: {acct_name} ({info['description']})")
            if config and CONFIG_FILE.exists():
                try:
                    config.setdefault("account", {})
                    config["account"]["name"] = acct_name
                    config["account"]["description"] = info["description"]
                    if info["corp_id"]:
                        config["account"]["corp_id"] = info["corp_id"]
                    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
                        json.dump(config, f, ensure_ascii=False, indent=2)
                    log("已自动写入 sync_config.json")
                except Exception as e:
                    log(f"写入配置失败: {e}", "WARN")

    if acct_name:
        acct_desc = config.get("account", {}).get("description", "") if config else ""
        log(f"账号: {acct_name} ({acct_desc})")

    if args.setup_task:
        return setup_task(args)

    if args.remove_task:
        return remove_task(args)

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
            print(f"  Token 剩余:  {status['hours_left']:.1f} 小时 ({status['expires_at']})")
        if status.get("refresh_hours_left") is not None:
            print(f"  Refresh 剩余: {status['refresh_hours_left']:.1f} 小时 ({status['refresh_expires_at']})")
        if not status["token_valid"] and status["refresh_token_valid"]:
            print("\nToken 已过期，尝试自动刷新...")
            ok, msg = try_auth_refresh()
            print(f"  {'成功' if ok else '失败'}: {msg}")
        return 0

    if args.login:
        print("正在启动钉钉扫码登录...\n")
        if not DWS_CORE:
            print("[ERROR] DWS 未初始化，无法登录")
            return 1
        try:
            # 交互式运行，让用户看到二维码并扫码
            ret = subprocess.call([DWS_CORE, "auth", "login"])
            if ret == 0:
                print("\n登录成功！")
                # 清除告警标志
                try:
                    if AUTH_ALERT_FILE.exists():
                        alert_data = json.loads(AUTH_ALERT_FILE.read_text(encoding="utf-8"))
                        alert_data["resolved"] = True
                        alert_data["resolved_at"] = datetime.now().isoformat()
                        with open(AUTH_ALERT_FILE, "w", encoding="utf-8") as f:
                            json.dump(alert_data, f, ensure_ascii=False, indent=2)
                except Exception:
                    pass
                # 刷新状态
                status = check_auth_status()
                save_auth_state(status)
                if status.get("hours_left") is not None:
                    print(f"Token 有效期至: {status.get('expires_at')} (剩余 {status['hours_left']:.1f}h)")
            else:
                print(f"\n登录失败 (exit code {ret})")
            return ret
        except Exception as e:
            print(f"\n登录过程出错: {e}")
            return 1

    if args.estimate:
        return run_estimate(args)

    log(f"钉钉同步工具 v{__version__} (Standalone)")
    log(f"工作目录: {BASE_DIR}")

    auth_ok, auth_msg = ensure_auth()
    if not auth_ok:
        log(f"认证检查未通过: {auth_msg}", "ERROR")
        write_log(f"认证检查未通过: {auth_msg}")
        return 2
    if auth_msg != "认证正常":
        log(f"认证: {auth_msg}")

    if args.days is None:
        if config:
            args.days = config.get("defaults", {}).get("days", 7)
        else:
            args.days = 7

    if config:
        features = config.get("features", {})
        if features.get("export_csv") and not args.export_csv and not args.all:
            args.all = True

    ret = 0

    dingtalk_token = getattr(args, 'dingtalk_token', '') or ''
    if not dingtalk_token and config:
        dingtalk_token = config.get("dingtalk", {}).get("access_token", "")

    # 新模块标志
    explicit_new = (args.sync_calendar or args.sync_todo
                    or args.sync_minutes or args.sync_all_new)
    # 常规同步标志（无特定标志时默认执行文件同步）
    explicit_regular = (args.all or args.export_csv
                        or args.retry_images or args.retry_files)

    # 仅指定新模块 → 跳过常规文件同步
    skip_regular = explicit_new and not explicit_regular

    if not skip_regular:
        if not args.export_csv or args.all:
            write_log(f"开始文件同步 (full={args.full}, days={args.days}, force={getattr(args, 'force', False)})")
            ret = run_sync(args)
            if ret == -1:
                log("同步已被用户取消", "WARN")
                write_log("同步已被用户取消")
                return 0  # 取消不算错误

        if args.retry_images:
            retry_failed_media(dingtalk_token)

        if args.retry_files:
            retry_failed_files()

        if args.export_csv or args.all:
            ret2 = run_export_csv(args)
            if ret2 != 0:
                ret = ret2

    # ---- 新模块: 日程 / 待办 / 听记 ----
    cal_days = getattr(args, 'calendar_days', 7) or 7
    with_transcript = getattr(args, 'with_transcript', False)

    if args.sync_calendar or args.sync_all_new:
        ret2 = sync_calendar(days_back=cal_days, days_forward=cal_days)
        if ret2 != 0:
            ret = ret2

    if args.sync_todo or args.sync_all_new:
        ret2 = sync_todo()
        if ret2 != 0:
            ret = ret2

    if args.sync_minutes or args.sync_all_new:
        ret2 = sync_minutes(include_transcript=with_transcript)
        if ret2 != 0:
            ret = ret2

    return ret


if __name__ == "__main__":
    sys.exit(main())
