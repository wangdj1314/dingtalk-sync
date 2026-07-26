#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
钉钉 Access Token 获取工具
============================
通过 appKey + appSecret 获取企业内部应用的 access_token。

用法:
  python get_token.py --app-key KEY --app-secret SECRET
  python get_token.py --save          # 获取后自动写入 config.json
"""
import argparse
import json
import sys
import urllib.request
import urllib.error
from pathlib import Path

CONFIG_FILE = Path(__file__).parent / "config.json"


def get_access_token(app_key, app_secret):
    """
    通过钉钉开放平台 API 获取企业内部应用 access_token。
    返回 (token, expires_in, error_msg)
    """
    url = "https://api.dingtalk.com/v1.0/oauth2/accessToken"
    payload = json.dumps({
        "appKey": app_key,
        "appSecret": app_secret,
    }).encode("utf-8")

    req = urllib.request.Request(url, data=payload, method="POST")
    req.add_header("Content-Type", "application/json")

    try:
        with urllib.request.urlopen(req, timeout=15) as response:
            data = json.loads(response.read().decode("utf-8"))
            token = data.get("accessToken", "")
            expires = data.get("expireIn", 0)
            if token:
                return token, expires, ""
            return "", 0, f"API 返回无 token: {json.dumps(data, ensure_ascii=False)}"
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace") if e.fp else ""
        return "", 0, f"HTTP {e.code}: {body[:300]}"
    except Exception as e:
        return "", 0, str(e)


def save_token_to_config(token):
    """将 token 写入 config.json 的 dingtalk.access_token"""
    config = {}
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, "r", encoding="utf-8") as f:
            config = json.load(f)

    config.setdefault("dingtalk", {})
    config["dingtalk"]["access_token"] = token

    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        json.dump(config, f, ensure_ascii=False, indent=2)

    print(f"Token 已写入: {CONFIG_FILE}")


def main():
    parser = argparse.ArgumentParser(description="获取钉钉 access_token")
    parser.add_argument("--app-key", required=True, help="企业内部应用的 AppKey")
    parser.add_argument("--app-secret", required=True, help="企业内部应用的 AppSecret")
    parser.add_argument("--save", action="store_true", help="获取后自动写入 config.json")
    args = parser.parse_args()

    print(f"正在获取 access_token...")
    print(f"  AppKey: {args.app_key}")

    token, expires, err = get_access_token(args.app_key, args.app_secret)

    if err:
        print(f"\n获取失败: {err}")
        print("\n请确认:")
        print("  1. AppKey 和 AppSecret 正确")
        print("  2. 应用已发布（非草稿状态）")
        print("  3. 网络可访问 api.dingtalk.com")
        return 1

    print(f"\n获取成功!")
    print(f"  Token: {token[:40]}...{token[-10:]}")
    print(f"  有效期: {expires} 秒 ({expires/3600:.1f} 小时)")
    print(f"\n完整 Token:\n  {token}")

    if args.save:
        save_token_to_config(token)
        print("\n后续运行同步脚本时无需再传 --dingtalk-token 参数。")
    else:
        print(f"\n使用方式:")
        print(f'  python dws_sync.py --all --days 7 --dingtalk-token "{token}"')
        print(f"  python dws_sync.py --retry-images --dingtalk-token \"{token}\"")
        print(f"\n或保存到 config（下次自动使用）:")
        print(f"  python get_token.py --app-key {args.app_key} --app-secret *** --save")

    return 0


if __name__ == "__main__":
    sys.exit(main())
