#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Combine batch results, deduplicate, and create download manifest"""
import json, os

SYNC_DIR = r"D:\myfiles\钉钉同步\_sync_state"
MANIFEST = os.path.join(SYNC_DIR, "download_manifest.json")

all_files = []
for batch in range(5):
    fp = os.path.join(SYNC_DIR, "batch_%d_results.json" % batch)
    if os.path.exists(fp):
        with open(fp, "r", encoding="utf-8") as f:
            files = json.load(f)
        print("Batch %d: %d files" % (batch, len(files)))
        all_files.extend(files)
    else:
        print("Batch %d: NOT FOUND" % batch)

print("\nTotal raw files:", len(all_files))

# Deduplicate by fileId
seen = {}
for f in all_files:
    fid = f.get("fileId", "")
    if fid and fid not in seen:
        seen[fid] = f

unique_files = list(seen.values())
print("Unique files (by fileId):", len(unique_files))

# Count by conversation
conv_counts = {}
for f in unique_files:
    title = f.get("convTitle", "unknown")
    conv_counts[title] = conv_counts.get(title, 0) + 1

print("\nTop 10 conversations by file count:")
for title, count in sorted(conv_counts.items(), key=lambda x: -x[1])[:10]:
    print("  %s: %d files" % (title, count))

# Save manifest
with open(MANIFEST, "w", encoding="utf-8") as f:
    json.dump(unique_files, f, ensure_ascii=False, indent=2)

print("\nManifest saved to:", MANIFEST)
print("Total files to download:", len(unique_files))
