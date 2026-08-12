#!/usr/bin/env python3
import json, sys, os

BASE = r"D:\myfiles\钉钉同步"
page_file = os.path.join(BASE, "_search_page4.json")

with open(page_file, "r", encoding="utf-8") as f:
    d = json.load(f)

r = d["result"]
convs = r["conversationMessagesList"]
has_more = r["hasMore"]
cursor = r.get("nextCursor", "")

print(f"Page 4: {len(convs)} conversations, hasMore={has_more}")
if cursor:
    print(f"nextCursor: {cursor[:60]}...")
else:
    print("nextCursor: None")

for c in convs:
    title = c["title"]
    n_msgs = len(c["messages"])
    # Count file messages
    file_count = sum(1 for m in c["messages"] if "[文件]" in m.get("content", ""))
    print(f"  {title}: {n_msgs} msgs ({file_count} files)")
