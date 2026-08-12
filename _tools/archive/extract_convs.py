#!/usr/bin/env python3
"""
Extract all unique conversations with file messages from search page JSON files.
Outputs: _all_file_convs.json with list of {convId, title, singleChat, fileCount}
"""
import json, os, glob, re

BASE = r"D:\myfiles\钉钉同步"

# Collect from all search page files
search_files = sorted(glob.glob(os.path.join(BASE, "_search_page*.json")))
print(f"Found {len(search_files)} search page files")

all_convs = {}  # convId -> {title, singleChat, fileMsgCount, latestFileDate}
total_msgs = 0

for sf in search_files:
    try:
        with open(sf, "r", encoding="utf-8") as f:
            d = json.load(f)
        convs = d["result"]["conversationMessagesList"]
        for c in convs:
            cid = c["openConversationId"]
            title = c["title"]
            single = c["singleChat"]
            file_msgs = [m for m in c["messages"] if "[\u6587\u4ef6]" in m.get("content", "")]
            
            if file_msgs:
                if cid not in all_convs:
                    all_convs[cid] = {
                        "convId": cid,
                        "title": title,
                        "singleChat": single,
                        "fileMsgCount": 0,
                        "latestFileDate": ""
                    }
                all_convs[cid]["fileMsgCount"] += len(file_msgs)
                for m in file_msgs:
                    dt = m.get("createTime", "")
                    if dt > all_convs[cid]["latestFileDate"]:
                        all_convs[cid]["latestFileDate"] = dt
                total_msgs += len(file_msgs)
    except Exception as e:
        print(f"Error processing {sf}: {e}")

# Check hasMore on last file
last_file = search_files[-1] if search_files else None
has_more = False
next_cursor = ""
if last_file:
    with open(last_file, "r", encoding="utf-8") as f:
        d = json.load(f)
    has_more = d["result"]["hasMore"]
    next_cursor = d["result"].get("nextCursor", "")

conv_list = list(all_convs.values())
conv_list.sort(key=lambda x: x["fileMsgCount"], reverse=True)

out_file = os.path.join(BASE, "_all_file_convs.json")
with open(out_file, "w", encoding="utf-8") as f:
    json.dump(conv_list, f, ensure_ascii=False, indent=2)

print(f"Unique conversations with files: {len(conv_list)}")
print(f"Total file messages found: {total_msgs}")
print(f"hasMore: {has_more}")
if next_cursor:
    print(f"nextCursor: {next_cursor[:80]}...")
print()
for c in conv_list[:20]:
    chat_type = "single" if c["singleChat"] else "group"
    print(f"  [{chat_type}] {c['title']}: {c['fileMsgCount']} files, latest: {c['latestFileDate'][:10]}")
print(f"  ... and {len(conv_list)-20} more")
