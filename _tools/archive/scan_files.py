#!/usr/bin/env python
"""
Scan DingTalk conversations for file messages and extract fileIds.
Processes batch_0.json and saves results.
"""
import json
import subprocess
import time
import os
import re
import sys

DWS_EXE = r"C:\Users\wangdj\.qoderworkcn\bin\dws-ext\dws-core-windows-amd64.exe"

# Support command-line arguments for batch/results/progress paths
if len(sys.argv) >= 4:
    BATCH_FILE = sys.argv[1]
    RESULTS_FILE = sys.argv[2]
    PROGRESS_FILE = sys.argv[3]
else:
    BATCH_FILE = r"C:\Users\wangdj\.qoderworkcn\workspace\mq18glq7rxvsormw\_batch_0.json"
    RESULTS_FILE = r"D:\myfiles\钉钉同步\_sync_state\batch_0_results.json"
    PROGRESS_FILE = r"D:\myfiles\钉钉同步\_sync_state\batch_0_progress.json"

def call_dws(args):
    """Call dws-core executable and return parsed JSON."""
    cmd = [DWS_EXE] + args
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60, encoding='utf-8')
        if result.stdout.strip():
            return json.loads(result.stdout)
        else:
            return None
    except Exception as e:
        print(f"  DWS call error: {e}", file=sys.stderr)
        return None

def get_space_id(conv_id):
    """Get spaceId for a conversation."""
    data = call_dws(["chat", "conversation-info", "--group", conv_id])
    if data and data.get("success"):
        return data.get("result", {}).get("conversationInfo", {}).get("extension", {}).get("newCSpaceIdIM", "")
    return ""

def scan_messages(conv_id):
    """Scan all messages in a conversation, handling pagination."""
    all_messages = []
    time_param = "2020-01-01 00:00:00"
    has_more = True
    page = 0
    
    while has_more:
        data = call_dws(["chat", "message", "list", "--group", conv_id, "--time", time_param, "--limit", "200"])
        time.sleep(0.3)
        
        if not data or not data.get("success"):
            print(f"    Failed to fetch messages page {page}", file=sys.stderr)
            break
        
        result = data.get("result", {})
        messages = result.get("messages", [])
        has_more = result.get("hasMore", False)
        
        all_messages.extend(messages)
        print(f"    Page {page}: {len(messages)} messages, hasMore={has_more}")
        
        if has_more and len(messages) > 0:
            time_param = messages[-1]["createTime"]
            page += 1
        else:
            has_more = False
    
    return all_messages

def extract_files(messages, conv_id, conv_title, space_id):
    """Extract file information from messages containing fileId."""
    files = []
    for msg in messages:
        content = msg.get("content", "")
        if "fileId: " in content:
            # Pattern: [文件] filename fileId: xxxxx
            # Extract filename between "[文件] " and " fileId:"
            # Extract fileId after "fileId: "
            match = re.search(r'\[文件\]\s*(.*?)\s*fileId:\s*(\S+)', content)
            if match:
                filename = match.group(1).strip()
                file_id = match.group(2).strip()
                files.append({
                    "fileId": file_id,
                    "filename": filename,
                    "createTime": msg.get("createTime", ""),
                    "sender": msg.get("sender", ""),
                    "convId": conv_id,
                    "convTitle": conv_title,
                    "spaceId": space_id
                })
    return files

def save_progress(scanned, total, files_found):
    """Save progress summary."""
    progress = {"scanned": scanned, "total": total, "filesFound": files_found}
    os.makedirs(os.path.dirname(PROGRESS_FILE), exist_ok=True)
    with open(PROGRESS_FILE, 'w', encoding='utf-8') as f:
        json.dump(progress, f, ensure_ascii=False, indent=2)

def main():
    # Load batch file
    print(f"Loading batch file: {BATCH_FILE}")
    with open(BATCH_FILE, 'r', encoding='utf-8') as f:
        conversations = json.load(f)
    
    total = len(conversations)
    print(f"Total conversations: {total}")
    
    all_files = []
    scanned = 0
    
    for i, conv in enumerate(conversations):
        conv_id = conv["convId"]
        title = conv["title"]
        print(f"\n=== [{i+1}/{total}] {title} ===")
        
        # Get spaceId
        space_id = get_space_id(conv_id)
        time.sleep(0.3)
        print(f"  SpaceId: {space_id}")
        
        # Scan messages
        print(f"  Scanning messages...")
        messages = scan_messages(conv_id)
        print(f"  Total messages: {len(messages)}")
        
        # Extract files
        files = extract_files(messages, conv_id, title, space_id)
        if files:
            print(f"  Found {len(files)} file(s)")
        else:
            print(f"  No files found")
        
        all_files.extend(files)
        scanned += 1
        
        # Save progress after each conversation
        save_progress(scanned, total, len(all_files))
    
    # Save final results
    print(f"\n=== Summary ===")
    print(f"Scanned: {scanned}/{total} conversations")
    print(f"Total files found: {len(all_files)}")
    
    os.makedirs(os.path.dirname(RESULTS_FILE), exist_ok=True)
    with open(RESULTS_FILE, 'w', encoding='utf-8') as f:
        json.dump(all_files, f, ensure_ascii=False, indent=2)
    print(f"Results saved to: {RESULTS_FILE}")
    
    save_progress(scanned, total, len(all_files))
    print(f"Progress saved to: {PROGRESS_FILE}")

if __name__ == "__main__":
    main()
