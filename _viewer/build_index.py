# -*- coding: utf-8 -*-
"""
生成聊天浏览网页所需的三份索引：

1. files_index.json  —— 各会话文件夹里已下载的文件（会话/日期/文件名/相对路径/大小）
2. conv_index.json   —— 每个会话的最新消息时间 + 最后一条消息预览 + 消息数
                        （供左侧列表按最近聊天排序并显示预览文字）
3. image_index.json  —— mediaId -> 本地图片相对路径（供聊天里 [图片消息](mediaId=xx) 渲染缩略图）

用法：
    python build_index.py

新同步下载了文件/图片、或聊天记录有更新后，重新运行本脚本即可刷新索引
（建议加入每日同步任务，紧跟在 dws_sync 之后）。
"""
import os
import re
import csv
import json
import datetime

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)  # 同步根目录（钉钉同步）

# 这些目录是工具/状态目录，不是会话文件夹，跳过
SKIP_DIRS = {"_viewer", "_tools", "_sync_state", "_chat_export", "_images"}

CHAT_EXPORT_DIR = os.path.join(ROOT, "_chat_export")
IMAGE_MANIFEST = os.path.join(ROOT, "_sync_state", "image_manifest.json")

IMG_MSG_RE = re.compile(r"\[图片消息\]\(mediaId=([^)]+)\)")

# 与同步脚本 / 前端 sanitize 保持一致：[<>:"/\|?*] -> _ 并去首尾空格
_SANITIZE_RE = re.compile(r'[<>:"/\\|?*]')


def sanitize_title(name):
    return _SANITIZE_RE.sub("_", str(name)).strip()


def human_size(n):
    for unit in ("B", "KB", "MB", "GB"):
        if n < 1024 or unit == "GB":
            return f"{n:.0f} {unit}" if unit == "B" else f"{n:.1f} {unit}"
        n /= 1024.0


# ---------------------------------------------------------------------------
# 1. 已下载文件索引
# ---------------------------------------------------------------------------
def build_files_index():
    files = []
    for name in sorted(os.listdir(ROOT)):
        full = os.path.join(ROOT, name)
        if not os.path.isdir(full):
            continue
        if name in SKIP_DIRS or name.startswith("."):
            continue
        for date_dir in sorted(os.listdir(full)):
            date_path = os.path.join(full, date_dir)
            if not os.path.isdir(date_path):
                continue
            for fn in sorted(os.listdir(date_path)):
                fpath = os.path.join(date_path, fn)
                if not os.path.isfile(fpath):
                    continue
                try:
                    size = os.path.getsize(fpath)
                except OSError:
                    size = 0
                rel = f"{name}/{date_dir}/{fn}"
                files.append({
                    "title": name,
                    "date": date_dir,
                    "filename": fn,
                    "path": rel,
                    "size": size,
                    "sizeText": human_size(size),
                })
    return files


# ---------------------------------------------------------------------------
# 2. 图片索引：mediaId -> 相对路径
# ---------------------------------------------------------------------------
def norm_media_id(mid):
    mid = (mid or "").strip()
    if mid.startswith("$"):
        mid = "@" + mid[1:]
    return mid


def local_to_rel(local_path):
    """把 manifest 里的绝对路径（可能是 D:\\myfiles\\... 旧盘符）转成
    相对同步根目录的 _images/... 相对路径。"""
    if not local_path:
        return None
    p = local_path.replace("\\", "/")
    idx = p.find("_images/")
    if idx == -1:
        return None
    return p[idx:]  # 从 _images/ 开始


def build_image_index():
    """返回 (by_media, by_key, by_open)：
    by_media: mediaId -> 相对路径
    by_key:   '会话\\x00时间\\x00发送人' -> [相对路径, ...]（兜底匹配，用于 mediaId 对不上时）
    by_open:  openMessageId -> 相对路径（若 chat 导出将来带上 openMessageId 可直接命中）
    """
    by_media = {}
    by_key = {}
    by_open = {}
    try:
        with open(IMAGE_MANIFEST, encoding="utf-8") as f:
            records = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return by_media, by_key, by_open
    for r in records:
        if not r.get("_downloaded"):
            continue
        rel = local_to_rel(r.get("_localPath"))
        if not rel or not os.path.isfile(os.path.join(ROOT, rel)):
            continue
        mid = norm_media_id(r.get("mediaId"))
        if mid:
            by_media[mid] = rel
        omid = norm_media_id(r.get("openMessageId"))
        if omid:
            by_open[omid] = rel
        title = sanitize_title(r.get("convTitle") or "")
        ctime = (r.get("createTime") or "").strip()
        sender = (r.get("sender") or "").strip()
        if title and ctime:
            k = title + "\x00" + ctime + "\x00" + sender
            by_key.setdefault(k, [])
            if rel not in by_key[k]:
                by_key[k].append(rel)
    return by_media, by_key, by_open


# ---------------------------------------------------------------------------
# 3.5 日程/会议汇总索引
# ---------------------------------------------------------------------------
_MEETING_URL_RE = re.compile(r"(?:https?://|dingtalk://)[^\s\)\]\}]+meeting\.dingtalk\.com/j/[A-Za-z0-9]+", re.I)
_SUBJECT_RE = re.compile(r"主题[\s：:]\s*(.+?)(?:\n|$)")


def _meeting_url(content):
    m = _MEETING_URL_RE.search(content or "")
    return m.group(0) if m else None


def _meeting_subject(content):
    m = _SUBJECT_RE.search(content or "")
    return m.group(1).strip() if m else None


def build_schedule_index():
    """扫描所有会话 CSV，收集日程/会议消息，供「日程」汇总面板使用。
    来源：type=calendar 的 [日程] 占位；以及含会议入会链接的 text 消息。
    返回按时间升序的列表：{time, sender, conv, kind, title, url}"""
    items = []
    if not os.path.isdir(CHAT_EXPORT_DIR):
        return items
    for fn in sorted(os.listdir(CHAT_EXPORT_DIR)):
        if not fn.lower().endswith(".csv"):
            continue
        if "_Conflict" in fn or "_conflict" in fn:
            continue
        title = fn[:-4]
        try:
            with open(os.path.join(CHAT_EXPORT_DIR, fn), encoding="utf-8-sig") as f:
                r = csv.reader(f)
                next(r, None)
                for row in r:
                    if len(row) < 4:
                        continue
                    t, sender, mtype, content = row[0], row[1], row[2], row[3]
                    if mtype == "empty":
                        continue
                    entry = None
                    if mtype == "calendar":
                        entry = {"time": t, "sender": sender, "conv": title,
                                 "kind": "calendar", "title": "[日程]", "url": ""}
                    else:
                        url = _meeting_url(content)
                        if url:
                            subj = _meeting_subject(content)
                            entry = {"time": t, "sender": sender, "conv": title,
                                     "kind": "meeting", "title": subj or "[日程]", "url": url}
                    if entry:
                        items.append(entry)
        except Exception:
            continue
    items.sort(key=lambda x: x["time"])
    return items


# ---------------------------------------------------------------------------
# 4. 会话索引：最新时间 + 最后一条预览 + 消息数
# ---------------------------------------------------------------------------
def make_preview(msg_type, content):
    """把一条消息压成一句预览文字。"""
    c = (content or "").strip()
    if msg_type == "file":
        mm = re.search(r"\[文件\]\s*([\s\S]*?)\s*fileId:", c)
        name = mm.group(1).strip() if mm else re.sub(r"^\s*\[文件\]\s*", "", c).strip()
        return "[文件] " + (name or "")
    if msg_type == "calendar":
        return "[日程]"
    if msg_type == "image":
        return "[图片]"
    # text：去掉图片标记 / 系统提示 / 富文本，压成纯文字
    # 纯图片消息
    stripped = IMG_MSG_RE.sub("", c).strip()
    had_img = stripped != c
    # 去掉"仅你和对方可见"等前缀提示
    stripped = re.sub(r"^\*\s*仅你和对方可见\s*", "", stripped).strip()
    # 翻译/卡片类 JSON 片段，直接忽略
    if stripped.startswith("[{") or stripped.startswith("{\""):
        stripped = ""
    # 去 HTML 标签
    stripped = re.sub(r"<[^>]+>", "", stripped)
    stripped = re.sub(r"\s+", " ", stripped).strip()
    if not stripped and had_img:
        return "[图片]"
    if stripped and had_img:
        return "[图片] " + stripped
    return stripped


def build_conv_index():
    convs = {}
    if not os.path.isdir(CHAT_EXPORT_DIR):
        return convs
    for fn in sorted(os.listdir(CHAT_EXPORT_DIR)):
        if not fn.lower().endswith(".csv"):
            continue
        if "_Conflict" in fn or "_conflict" in fn:
            continue
        title = fn[:-4]  # 去 .csv，已是清洗后的标题
        path = os.path.join(CHAT_EXPORT_DIR, fn)
        best = None      # (time, type, content)
        seen = set()
        count = 0
        try:
            with open(path, encoding="utf-8-sig") as f:
                r = csv.reader(f)
                header = next(r, None)
                for row in r:
                    if len(row) < 4:
                        continue
                    t, sender, mtype, content = row[0], row[1], row[2], row[3]
                    if mtype == "empty":
                        continue
                    key = (t, sender, mtype, content)
                    if key in seen:
                        continue
                    seen.add(key)
                    count += 1
                    if best is None or t > best[0]:
                        best = (t, mtype, content)
        except Exception:
            continue
        if best is None:
            convs[title] = {"lastTime": "", "preview": "", "count": 0}
        else:
            convs[title] = {
                "lastTime": best[0],
                "preview": make_preview(best[1], best[2])[:60],
                "count": count,
            }
    return convs


# ---------------------------------------------------------------------------
# 5. 日历/日程索引（来自 _calendar_export/*.csv，合并去重）
# ---------------------------------------------------------------------------
def _epoch_ms_to_iso(ms):
    try:
        ms = int(ms)
    except (TypeError, ValueError):
        return ""
    dt = datetime.datetime.fromtimestamp(ms / 1000)
    return dt.strftime("%Y-%m-%d %H:%M:%S")


def _dur_to_text(ms):
    try:
        ms = int(ms)
    except (TypeError, ValueError):
        return ""
    sec = ms // 1000
    h, m = divmod(sec // 60, 60)
    s = sec % 60
    if h:
        return f"{h}小时{m}分"
    if m:
        return f"{m}分{s}秒" if s else f"{m}分"
    return f"{s}秒"


def build_calendar_index():
    """合并 _calendar_export 下所有 CSV，按 id 去重，按 start_time 升序。"""
    events = {}
    d = os.path.join(ROOT, "_calendar_export")
    if not os.path.isdir(d):
        return []
    for fn in sorted(os.listdir(d)):
        if not fn.lower().endswith(".csv"):
            continue
        try:
            with open(os.path.join(d, fn), encoding="utf-8-sig") as f:
                for row in csv.DictReader(f):
                    eid = (row.get("id") or "").strip()
                    if not eid:
                        continue
                    if eid in events:
                        continue
                    attendees = [a.strip() for a in (row.get("attendees") or "").split(";") if a.strip()]
                    st = (row.get("start_time") or "").strip()
                    et = (row.get("end_time") or "").strip()
                    # 去掉 +08:00 用于排序（同口径字符串比较即可）
                    sort_key = st.replace("+08:00", "").replace("Z", "") if st else "9" * 20
                    events[eid] = {
                        "id": eid,
                        "summary": (row.get("summary") or "").strip(),
                        "startTime": st,
                        "endTime": et,
                        "startDate": st[:10] if st else "",
                        "startClock": st[11:16] if len(st) > 16 else "",
                        "endClock": et[11:16] if len(et) > 16 else "",
                        "isAllDay": (row.get("is_all_day") or "").strip().lower() == "true",
                        "organizer": (row.get("organizer") or "").strip(),
                        "attendeeCount": (row.get("attendee_count") or "").strip(),
                        "attendees": attendees,
                        "location": (row.get("location") or "").strip(),
                        "meetingRoom": (row.get("meeting_room") or "").strip(),
                        "status": (row.get("status") or "").strip(),
                        "onlineMeetingType": (row.get("online_meeting_type") or "").strip(),
                        "onlineMeetingCode": (row.get("online_meeting_code") or "").strip(),
                        "description": (row.get("description") or "").strip(),
                        "categories": (row.get("categories") or "").strip(),
                        "_sort": sort_key,
                    }
        except Exception:
            continue
    return sorted(events.values(), key=lambda x: x["_sort"])


# ---------------------------------------------------------------------------
# 6. 待办索引（来自 _todo_export/*.csv，合并去重）
# ---------------------------------------------------------------------------
_STATUS_ORDER = {"未完成": 0, "进行中": 1, "已完成": 2, "已取消": 3}


def build_todo_index():
    todos = {}
    d = os.path.join(ROOT, "_todo_export")
    if not os.path.isdir(d):
        return []
    for fn in sorted(os.listdir(d)):
        if not fn.lower().endswith(".csv"):
            continue
        try:
            with open(os.path.join(d, fn), encoding="utf-8-sig") as f:
                for row in csv.DictReader(f):
                    tid = (row.get("task_id") or "").strip()
                    if not tid or tid in todos:
                        continue
                    todos[tid] = {
                        "taskId": tid,
                        "subject": (row.get("subject") or "").strip(),
                        "status": (row.get("status") or "").strip(),
                        "priority": (row.get("priority") or "").strip(),
                        "priorityLabel": (row.get("priority_label") or "").strip(),
                        "dueTime": (row.get("due_time") or "").strip(),
                        "createdTime": (row.get("created_time") or "").strip(),
                    }
        except Exception:
            continue
    items = list(todos.values())
    items.sort(key=lambda x: (_STATUS_ORDER.get(x["status"], 9),
                               x["dueTime"] or "9" * 20,
                               x["createdTime"] or "9" * 20), reverse=False)
    return items


# ---------------------------------------------------------------------------
# 7. 听记/会议纪要索引（来自 _minutes_export/*.json）
# ---------------------------------------------------------------------------
def build_minutes_index():
    minutes = []
    d = os.path.join(ROOT, "_minutes_export")
    if not os.path.isdir(d):
        return []
    for fn in sorted(os.listdir(d)):
        if not fn.lower().endswith(".json"):
            continue
        try:
            j = json.load(open(os.path.join(d, fn), encoding="utf-8"))
        except Exception:
            continue
        basic = (j.get("basic") or {}).get("result") or {}
        summ = (j.get("summary") or {}).get("result") or {}
        kw = (j.get("keywords") or {}).get("result") or {}
        todos_block = (j.get("todos") or {}).get("result") or {}
        actions = todos_block.get("actions") or []
        # actions 可能是字符串列表，也可能含 JSON 字符串
        clean_actions = []
        for a in actions:
            if isinstance(a, str):
                try:
                    obj = json.loads(a)
                    clean_actions.append(obj.get("value") or obj.get("title") or a)
                except Exception:
                    clean_actions.append(a)
            elif isinstance(a, dict):
                clean_actions.append(a.get("value") or a.get("title") or "")
            else:
                clean_actions.append(str(a))
        minutes.append({
            "taskUuid": j.get("taskUuid") or basic.get("taskUuid") or "",
            "title": basic.get("title") or "",
            "url": basic.get("url") or "",
            "startTime": _epoch_ms_to_iso(basic.get("startTime")),
            "endTime": _epoch_ms_to_iso(basic.get("endTime")),
            "durationText": _dur_to_text(basic.get("duration")),
            "keywords": kw.get("keywords") or [],
            "summary": summ.get("fullSummary") or "",
            "actions": [a for a in clean_actions if a],
        })
    # 按开始时间倒序（新的在前）
    minutes.sort(key=lambda x: x["startTime"] or "", reverse=True)
    return minutes


def main():
    now = datetime.datetime.now().isoformat(timespec="seconds")

    files = build_files_index()
    with open(os.path.join(HERE, "files_index.json"), "w", encoding="utf-8") as f:
        json.dump({"generatedAt": now, "count": len(files), "files": files},
                  f, ensure_ascii=False, indent=1)
    print(f"files_index.json  —— {len(files)} 个已下载文件")

    by_media, by_key, by_open = build_image_index()
    with open(os.path.join(HERE, "image_index.json"), "w", encoding="utf-8") as f:
        json.dump({"generatedAt": now, "count": len(by_media),
                   "images": by_media, "byKey": by_key, "byOpen": by_open},
                  f, ensure_ascii=False, indent=0)
    total_by_key = sum(len(v) for v in by_key.values())
    print(f"image_index.json  —— {len(by_media)} 张(按mediaId) / {total_by_key} 张(按时间兜底) / {len(by_open)} 张(openMessageId)")

    schedule = build_schedule_index()
    with open(os.path.join(HERE, "schedule_index.json"), "w", encoding="utf-8") as f:
        json.dump({"generatedAt": now, "count": len(schedule), "items": schedule},
                  f, ensure_ascii=False, indent=0)
    print(f"schedule_index.json —— {len(schedule)} 条日程/会议")

    convs = build_conv_index()
    with open(os.path.join(HERE, "conv_index.json"), "w", encoding="utf-8") as f:
        json.dump({"generatedAt": now, "count": len(convs), "convs": convs},
                  f, ensure_ascii=False, indent=0)
    print(f"conv_index.json   —— {len(convs)} 个会话（含最新时间与预览）")

    calendar = build_calendar_index()
    with open(os.path.join(HERE, "calendar_index.json"), "w", encoding="utf-8") as f:
        json.dump({"generatedAt": now, "count": len(calendar), "events": calendar},
                  f, ensure_ascii=False, indent=0)
    print(f"calendar_index.json —— {len(calendar)} 条日程/会议")

    todos = build_todo_index()
    with open(os.path.join(HERE, "todo_index.json"), "w", encoding="utf-8") as f:
        json.dump({"generatedAt": now, "count": len(todos), "todos": todos},
                  f, ensure_ascii=False, indent=0)
    print(f"todo_index.json   —— {len(todos)} 条待办")

    minutes = build_minutes_index()
    with open(os.path.join(HERE, "minutes_index.json"), "w", encoding="utf-8") as f:
        json.dump({"generatedAt": now, "count": len(minutes), "minutes": minutes},
                  f, ensure_ascii=False, indent=0)
    print(f"minutes_index.json —— {len(minutes)} 条听记/会议纪要")


if __name__ == "__main__":
    main()
