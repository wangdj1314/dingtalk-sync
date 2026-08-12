#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Phase 1: Get spaceIds for all conversations"""
import json, subprocess, os, time

CONVS_FILE = r"D:\myfiles\钉钉同步\_all_convs.json"
OUT_FILE = r"D:\myfiles\钉钉同步\_sync_state\space_ids.json"

convs = json.load(open(CONVS_FILE, "r", encoding="utf-8"))
print("Total conversations:", len(convs))

space_ids = {}
if os.path.exists(OUT_FILE):
    space_ids = json.load(open(OUT_FILE, "r", encoding="utf-8"))
    print("Already have spaceIds for:", len(space_ids))

count = 0
errors = 0
for i, c in enumerate(convs):
    cid = c["convId"]
    title = c["title"]
    if cid in space_ids:
        continue
    count += 1
    
    tmp_script = r"C:\Users\wangdj\.qoderworkcn\workspace\mq18glq7rxvsormw\_tmp_cmd.bat"
    with open(tmp_script, "w") as f:
        f.write("@echo off\n")
        f.write('dws chat conversation-info --group "' + cid + '" 2>&1\n')
    
    try:
        result = subprocess.run(tmp_script, capture_output=True, text=True, timeout=30, shell=True)
        d = json.loads(result.stdout)
        info = d.get("result", {}).get("conversationInfo", {})
        ext = info.get("extension", {})
        sid = ext.get("newCSpaceIdIM", "")
        actual_title = info.get("title", title)
        space_ids[cid] = {"spaceId": sid, "title": actual_title}
        if count <= 5 or count % 10 == 0:
            print("  [{}] {}: spaceId={}".format(count, actual_title, sid))
    except Exception as e:
        errors += 1
        space_ids[cid] = {"spaceId": "", "title": title, "error": str(e)[:100]}
        if count <= 5 or count % 10 == 0:
            print("  [{}] {}: ERROR {}".format(count, title, str(e)[:80]))
    
    if count % 10 == 0:
        json.dump(space_ids, open(OUT_FILE, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
    
    time.sleep(0.2)

json.dump(space_ids, open(OUT_FILE, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
print("Done. Processed:", count, "Errors:", errors)
has_space = sum(1 for v in space_ids.values() if v.get("spaceId"))
print("With spaceId:", has_space)
print("Without spaceId:", len(space_ids) - has_space)
