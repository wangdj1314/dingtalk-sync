#!/usr/bin/env python3
"""Check a search page JSON file and output summary + cursor"""
import json, sys, os

page_file = sys.argv[1]
with open(page_file, "r", encoding="utf-8") as f:
    d = json.load(f)

r = d["result"]
convs = r["conversationMessagesList"]
has_more = r["hasMore"]
cursor = r.get("nextCursor", "")

file_conv_ids = set()
for c in convs:
    for m in c["messages"]:
        if "[文件]" in m.get("content", ""):
            file_conv_ids.add(c["openConversationId"])
            break

print(f"Conversations: {len(convs)}, With files: {len(file_conv_ids)}, hasMore: {has_more}")
if cursor:
    print(f"CURSOR:{cursor}")
else:
    print("CURSOR:NONE")
