#!/usr/bin/env python
"""
Deduplicate the batch_0_results.json file.
Pagination overlap causes duplicate file entries when the last message
of one page is the same as the boundary message on the next page.
"""
import json
import os

RESULTS_FILE = r"D:\myfiles\钉钉同步\_sync_state\batch_0_results.json"
PROGRESS_FILE = r"D:\myfiles\钉钉同步\_sync_state\batch_0_progress.json"

# Load results
with open(RESULTS_FILE, 'r', encoding='utf-8') as f:
    results = json.load(f)

print(f"Total entries before dedup: {len(results)}")

# Deduplicate based on (fileId, createTime, convId, sender, filename)
seen = set()
unique_results = []
for entry in results:
    key = (entry["fileId"], entry["createTime"], entry["convId"], entry["sender"], entry["filename"])
    if key not in seen:
        seen.add(key)
        unique_results.append(entry)

print(f"Total entries after dedup: {len(unique_results)}")

# Save deduplicated results
with open(RESULTS_FILE, 'w', encoding='utf-8') as f:
    json.dump(unique_results, f, ensure_ascii=False, indent=2)

# Update progress
progress = {"scanned": 17, "total": 17, "filesFound": len(unique_results)}
with open(PROGRESS_FILE, 'w', encoding='utf-8') as f:
    json.dump(progress, f, ensure_ascii=False, indent=2)

print(f"Results saved: {RESULTS_FILE}")
print(f"Progress saved: {PROGRESS_FILE}")

# Print summary per conversation
from collections import Counter
conv_counts = Counter(e["convTitle"] for e in unique_results)
print("\nFiles per conversation:")
for title, count in conv_counts.most_common():
    print(f"  {title}: {count}")
