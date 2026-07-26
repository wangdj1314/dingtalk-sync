#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试钉钉原生媒体下载 API
用法: python test_image_download.py --token YOUR_TOKEN --media-id MEDIA_ID
"""
import argparse
import json
import sys
import urllib.request
import urllib.error
from pathlib import Path

# 从 image_manifest 里取一个失败的 mediaId 做测试
IMAGE_MANIFEST = Path(__file__).parent.parent / "_sync_state" / "image_manifest.json"


def test_download(access_token, media_id, output_dir="."):
    """通过钉钉原生 media download API 下载图片"""
    url = f"https://oapi.dingtalk.com/media/download?access_token={access_token}&media_id={media_id}"
    
    print(f"Testing download...")
    print(f"  media_id: {media_id}")
    print(f"  URL: {url[:100]}...")
    
    try:
        req = urllib.request.Request(url)
        req.add_header("User-Agent", "DingTalkSync/1.0")
        
        with urllib.request.urlopen(req, timeout=30) as response:
            content_type = response.headers.get("Content-Type", "")
            content_length = response.headers.get("Content-Length", "unknown")
            
            print(f"  Status: {response.status}")
            print(f"  Content-Type: {content_type}")
            print(f"  Content-Length: {content_length}")
            
            if "json" in content_type or "text" in content_type:
                # 可能返回了错误 JSON
                body = response.read().decode("utf-8", errors="replace")
                print(f"  Body: {body[:500]}")
                return False, "API returned JSON (possibly error)"
            else:
                # 二进制内容 = 图片
                data = response.read()
                ext = ".jpg"
                if "png" in content_type:
                    ext = ".png"
                elif "gif" in content_type:
                    ext = ".gif"
                elif "webp" in content_type:
                    ext = ".webp"
                
                out_path = Path(output_dir) / f"test_download{ext}"
                out_path.write_bytes(data)
                print(f"  Saved: {out_path} ({len(data)} bytes)")
                return True, str(out_path)
                
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace") if e.fp else ""
        print(f"  HTTP Error: {e.code}")
        print(f"  Body: {body[:500]}")
        return False, f"HTTP {e.code}: {body[:200]}"
        
    except urllib.error.URLError as e:
        print(f"  URL Error: {e.reason}")
        return False, str(e.reason)
        
    except Exception as e:
        print(f"  Error: {e}")
        return False, str(e)


def main():
    parser = argparse.ArgumentParser(description="Test DingTalk native media download API")
    parser.add_argument("--token", required=True, help="DingTalk access_token")
    parser.add_argument("--media-id", default="", help="mediaId to test (empty = pick from manifest)")
    parser.add_argument("--output", default=".", help="Output directory")
    args = parser.parse_args()
    
    media_id = args.media_id
    
    # 如果没有指定 media_id，从 manifest 里取一个
    if not media_id:
        if IMAGE_MANIFEST.exists():
            data = json.loads(IMAGE_MANIFEST.read_text(encoding="utf-8"))
            # 找一个有 _error 的
            for r in data:
                if r.get("_error") and "unsupported" in r.get("_error", ""):
                    media_id = r["mediaId"]
                    print(f"Picked from manifest: {media_id}")
                    break
        if not media_id:
            print("No media_id specified and none found in manifest")
            return 1
    
    ok, result = test_download(args.token, media_id, args.output)
    
    if ok:
        print(f"\nSUCCESS: {result}")
        print("The native media download API works! We can use this as a fallback.")
    else:
        print(f"\nFAILED: {result}")
        print("The native API might not support this mediaId format.")
        print("Try the --media-id flag with a different ID.")
    
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
