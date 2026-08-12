#!/bin/bash
# Script to scan all DingTalk conversations for file messages
DWS="C:/Users/wangdj/.qoderworkcn/bin/dws-ext/dws-core-windows-amd64.exe"
OUTDIR="/tmp/batch_scan"
WORKSPACE="C:/Users/wangdj/.qoderworkcn/workspace/mq18glq7rxvsormw"

mkdir -p "$OUTDIR/conv_info"
mkdir -p "$OUTDIR/messages"

# Extract convIds and titles from batch file using python
python -c "
import json, sys
with open(r'C:\Users\wangdj\.qoderworkcn\workspace\mq18glq7rxvsormw\_batch_0.json', 'r', encoding='utf-8') as f:
    convs = json.load(f)
for i, c in enumerate(convs):
    print(f'{i}|{c[\"convId\"]}|{c[\"title\"]}|{c[\"singleChat\"]}')
" > "$OUTDIR/conv_list.txt"

TOTAL=$(wc -l < "$OUTDIR/conv_list.txt")
echo "Total conversations: $TOTAL"
SCANNED=0

while IFS='|' read -r IDX CONVID TITLE SINGLECHAT; do
    echo "=== Processing [$((SCANNED+1))/$TOTAL]: $TITLE (convId=$CONVID) ==="
    
    # Get conversation info for spaceId
    echo "  Getting conversation info..."
    "$DWS" chat conversation-info --group "$CONVID" > "$OUTDIR/conv_info/${IDX}.json" 2>&1
    sleep 0.3
    
    # Extract spaceId using python reading from the output file
    SPACEID=$(python -c "
import json, sys
try:
    with open(r'C:\Users\wangdj\AppData\Local\Temp\batch_scan\conv_info\${IDX}.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    print(data.get('result',{}).get('conversationInfo',{}).get('extension',{}).get('newCSpaceIdIM',''))
except Exception as e:
    print('')
" 2>/dev/null)
    echo "  SpaceId: $SPACEID"
    
    # Save spaceId to a simple text file for later use
    echo "$SPACEID" > "$OUTDIR/conv_info/${IDX}_spaceid.txt"
    
    # Scan messages with pagination
    PAGE=0
    TIME_PARAM="2020-01-01 00:00:00"
    HAS_MORE="true"
    
    while [ "$HAS_MORE" = "true" ]; do
        echo "  Fetching messages page $PAGE (time=$TIME_PARAM)..."
        MSGFILE="$OUTDIR/messages/${IDX}_page${PAGE}.json"
        "$DWS" chat message list --group "$CONVID" --time "$TIME_PARAM" --limit 200 > "$MSGFILE" 2>&1
        sleep 0.3
        
        # Check hasMore and get last message time for pagination
        RESULT=$(python -c "
import json, sys
try:
    import os
    # Convert MSYS path to Windows path for Python
    msgfile = r'C:\Users\wangdj\AppData\Local\Temp\batch_scan\messages\${IDX}_page${PAGE}.json'
    with open(msgfile, 'r', encoding='utf-8') as f:
        data = json.load(f)
    result = data.get('result', {})
    has_more = result.get('hasMore', False)
    messages = result.get('messages', [])
    if has_more and len(messages) > 0:
        last_time = messages[-1]['createTime']
    else:
        last_time = ''
    print(f'{str(has_more).lower()}|{last_time}|{len(messages)}')
except Exception as e:
    print(f'false||0|error: {e}')
" 2>/dev/null)
        
        HAS_MORE=$(echo "$RESULT" | cut -d'|' -f1)
        LAST_TIME=$(echo "$RESULT" | cut -d'|' -f2)
        MSG_COUNT=$(echo "$RESULT" | cut -d'|' -f3)
        
        echo "    Got $MSG_COUNT messages, hasMore=$HAS_MORE"
        
        if [ "$HAS_MORE" = "true" ] && [ -n "$LAST_TIME" ]; then
            TIME_PARAM="$LAST_TIME"
            PAGE=$((PAGE+1))
        else
            HAS_MORE="false"
        fi
    done
    
    SCANNED=$((SCANNED+1))
    echo "  Done with $TITLE ($SCANNED/$TOTAL)"
    echo ""
done < "$OUTDIR/conv_list.txt"

echo "=== All conversations scanned ==="
echo "Scanned: $SCANNED / $TOTAL"
