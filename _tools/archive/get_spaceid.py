import json, sys

# Try to read the file
try:
    idx = sys.argv[1]
    fpath = r'C:\Users\wangdj\AppData\Local\Temp\batch_scan\conv_info' + '\\' + idx + '.json'
    print(f"Reading: {fpath}", file=sys.stderr)
    with open(fpath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    spaceid = data.get('result',{}).get('conversationInfo',{}).get('extension',{}).get('newCSpaceIdIM','')
    print(spaceid)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    print('')
