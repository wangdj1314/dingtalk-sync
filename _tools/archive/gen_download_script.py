#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Generate a bash download script from the manifest.
The bash script will call dws drive download for each file,
then curl to download, saving to organized directories.
"""
import json, os, re

MANIFEST = r"D:\myfiles\钉钉同步\_sync_state\download_manifest.json"
DOWNLOAD_DIR = r"D:\myfiles\钉钉同步"
SCRIPT_OUT = r"C:\Users\wangdj\.qoderworkcn\workspace\mq18glq7rxvsormw\download_batch.sh"
PROGRESS = r"D:\myfiles\钉钉同步\_sync_state\downloaded.json"

ILLEGAL = re.compile(r'[<>:"/\\|?*\x00-\x1f]')

def safe_name(name):
    name = ILLEGAL.sub("_", name).strip(" .")
    if len(name) > 120:
        base, ext = os.path.splitext(name)
        name = base[:120 - len(ext)] + ext
    return name or "unnamed"

def safe_dir(name):
    name = ILLEGAL.sub("_", name).strip(" .")
    if len(name) > 80:
        name = name[:80]
    return name or "unknown"

# Load manifest
files = json.load(open(MANIFEST, "r", encoding="utf-8"))
print("Files to process:", len(files))

# Load already downloaded
downloaded = set()
if os.path.exists(PROGRESS):
    downloaded = set(json.load(open(PROGRESS, "r", encoding="utf-8")))
    print("Already downloaded:", len(downloaded))

# Filter
to_download = [f for f in files if f["fileId"] not in downloaded]
print("To download:", len(to_download))

# Generate bash script
lines = [
    '#!/bin/bash',
    'set -e',
    'OK=0',
    'FAIL=0',
    'EXPIRE=0',
    'TOTAL=%d' % len(to_download),
    'PROGRESS_FILE="%s"' % PROGRESS.replace('\\', '/'),
    '',
    'echo "Starting download of $TOTAL files..."',
    '',
]

for idx, f in enumerate(to_download):
    fid = f["fileId"]
    fname = safe_name(f.get("filename", "unknown"))
    space_id = f.get("spaceId", "")
    title = safe_dir(f.get("convTitle", "unknown"))
    ct = f.get("createTime", "")
    date_str = ct[:10] if ct and len(ct) >= 10 else "unknown"
    
    target_dir = os.path.join(DOWNLOAD_DIR, title, date_str).replace('\\', '/')
    
    lines.append('# [%d/%d] %s' % (idx+1, len(to_download), f.get("filename", "?")))
    lines.append('mkdir -p "%s"' % target_dir)
    
    # Get download URL
    lines.append('RESULT=$(dws drive download --file-id "%s" --space-id "%s" 2>&1)' % (fid, space_id))
    lines.append('URL=$(echo "$RESULT" | python -c "import sys,json; d=json.load(sys.stdin); print(d.get(\'result\',{}).get(\'downloadUrl\',\'\'))" 2>/dev/null || echo "")')
    
    # Download if URL exists
    lines.append('if [ -n "$URL" ]; then')
    lines.append('  if curl -sS -L --connect-timeout 30 --max-time 120 -o "%s/%s" "$URL" 2>/dev/null; then' % (target_dir, fname))
    lines.append('    SIZE=$(stat -c%%s "%s/%s" 2>/dev/null || echo 0)' % (target_dir, fname))
    lines.append('    if [ "$SIZE" -gt 0 ]; then')
    lines.append('      echo "  [%d/%d] OK: %s ($SIZE bytes)"' % (idx+1, len(to_download), fname))
    lines.append('      OK=$((OK+1))')
    lines.append('    else')
    lines.append('      echo "  [%d/%d] FAIL: %s (empty file)"' % (idx+1, len(to_download), fname))
    lines.append('      rm -f "%s/%s"' % (target_dir, fname))
    lines.append('      FAIL=$((FAIL+1))')
    lines.append('    fi')
    lines.append('  else')
    lines.append('    echo "  [%d/%d] FAIL: %s (curl error)"' % (idx+1, len(to_download), fname))
    lines.append('    rm -f "%s/%s"' % (target_dir, fname))
    lines.append('    FAIL=$((FAIL+1))')
    lines.append('  fi')
    lines.append('else')
    lines.append('  echo "  [%d/%d] EXPIRED: %s"' % (idx+1, len(to_download), fname))
    lines.append('  EXPIRE=$((EXPIRE+1))')
    lines.append('fi')
    
    # Save progress every 20 files
    if (idx + 1) % 20 == 0:
        lines.append('echo "Progress: %d/$TOTAL done"' % (idx+1))
    
    lines.append('sleep 0.2')
    lines.append('')

lines.extend([
    '',
    'echo ""',
    'echo "=============================="',
    'echo "Download complete!"',
    'echo "  Downloaded: $OK"',
    'echo "  Failed: $FAIL"',
    'echo "  Expired: $EXPIRE"',
    'echo "  Total: $TOTAL"',
    'echo "=============================="',
])

with open(SCRIPT_OUT, "w", encoding="utf-8", newline='\n') as f:
    f.write('\n'.join(lines))

print("Download script generated:", SCRIPT_OUT)
print("Contains %d download commands" % len(to_download))
