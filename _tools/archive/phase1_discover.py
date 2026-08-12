#!/usr/bin/env python3
"""Phase 1: Discover all conversations by paginating list-all"""
import json, os, sys, time, subprocess

OUTPUT_DIR = r"D:\myfiles\钉钉同步"
CONV_FILE = os.path.join(OUTPUT_DIR, "_conversations.json")
CURSOR_FILE = os.path.join(OUTPUT_DIR, "_cursor.txt")

# Load existing conversations
conversations = {}
if os.path.exists(CONV_FILE):
    with open(CONV_FILE, "r", encoding="utf-8") as f:
        conversations = json.load(f)

# Load cursor
cursor = "0"
if os.path.exists(CURSOR_FILE):
    with open(CURSOR_FILE, "r") as f:
        cursor = f.read().strip()
    if not cursor:
        cursor = "0"

page = 0
max_pages = 500
new_in_round = 0

while page < max_pages:
    page += 1
    time.sleep(0.5)
    
    cmd = 'dws chat message list-all --start "2020-01-01 00:00:00" --end "2027-12-31 23:59:59" --limit 50 --cursor "%s" --format json' % cursor
    
    # Run via shell to get proper dws execution
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=120, shell=True)
    
    if result.returncode != 0:
        print("Error on page %d: %s" % (page, result.stderr[:100]))
        break
    
    stdout = result.stdout.strip()
    # Skip pending-post-tool-use messages
    if "pending-post-tool-use" in stdout:
        print("Page %d: dws pending, stopping" % page)
        break
    
    try:
        data = json.loads(stdout)
    except json.JSONDecodeError:
        print("Page %d: JSON parse error, stdout[:100]=%s" % (page, repr(stdout[:100])))
        break
    
    r = data.get("result", data)
    conv_list = r.get("conversationMessagesList", [])
    has_more = r.get("hasMore", False)
    next_cursor = r.get("nextCursor", "")
    
    new_this_page = 0
    for c in conv_list:
        cid = c.get("openConversationId", "")
        if cid and cid not in conversations:
            conversations[cid] = {
                "title": c.get("title", "Unknown"),
                "singleChat": c.get("singleChat", False),
                "convId": cid
            }
            new_this_page += 1
    
    new_in_round += new_this_page
    cursor = next_cursor
    
    if page % 10 == 0:
        print("Page %d: total=%d, new_this_round=%d, hasMore=%s" % (page, len(conversations), new_in_round, has_more))
    
    # Save periodically
    if page % 20 == 0:
        with open(CONV_FILE, "w", encoding="utf-8") as f:
            json.dump(conversations, f, ensure_ascii=False, indent=2)
        with open(CURSOR_FILE, "w") as f:
            f.write(cursor)
    
    if not has_more or not next_cursor:
        print("No more pages at page %d" % page)
        break

# Final save
with open(CONV_FILE, "w", encoding="utf-8") as f:
    json.dump(conversations, f, ensure_ascii=False, indent=2)
with open(CURSOR_FILE, "w") as f:
    f.write(cursor)

print("\nPhase 1 complete: %d unique conversations discovered" % len(conversations))
print("New this round: %d" % new_in_round)
