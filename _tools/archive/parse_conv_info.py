#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""处理 dws conversation-info 输出，提取 spaceId"""
import sys, json

try:
    d = json.load(sys.stdin)
    info = d.get("result", {}).get("conversationInfo", {})
    ext = info.get("extension", {})
    sid = ext.get("newCSpaceIdIM", "")
    title = info.get("title", "")
    print(json.dumps({"spaceId": sid, "title": title}))
except Exception as e:
    print(json.dumps({"spaceId": "", "title": "", "error": str(e)}))
