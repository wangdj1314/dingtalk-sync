#!/usr/bin/env python3
"""
Extract all unique conversations with file messages from ALL search results.
Handles both saved file pages and inline data from pages 1-3.
"""
import json, os, glob

BASE = r"D:\myfiles\钉钉同步"

# All conversations from pages 1-3 inline data (manually extracted from context)
# Format: (openConversationId, title, singleChat)
inline_convs = [
    # Page 1
    ("cidBs2FWtLLlAOcbBilFGSJ6RePL0/ZlRPJwUr7VHIk1qk=", "\u949f\u5efa\u5b87", True),
    ("cidoRglXiy4VqyeaaPZeOxgYw==", "APIS\u96c6\u6210\u5f00\u53d1\u8fd0\u7ef4\u7fa4", False),
    ("cidHH9Uv8BKruhshYeqSH5QJUX5wby+FqFIi79iEaKOEBc=", "\u5f20\u6d25\u6cfd", True),
    ("cid0ztFmDh/N+uHEzc/lLvHI0X5wby+FqFIi79iEaKOEBc=", "\u8bb8\u660e\u80dc", True),
    ("cideJmFmijEZnUju6RtfRfSdg==", "\u6ec1\u5dde\u81ea\u7814MES\u5b9e\u65bd", False),
    ("cidalXaRGNjbfH5imGTGYvadkX5wby+FqFIi79iEaKOEBc=", "\u738b\u747e", True),
    ("cidzohmfKXMWJcTHYcCnDzWag==", "IT\u5404\u7ec4\u8d1f\u8d23\u4eba\u7fa4", False),
    ("cid9FR+kNQLP4JZ/aoeTUfS8Q==", "\u4f1a\u8bae\u7eaa\u8981\u5185\u5bb9\u786e\u8ba4", False),
    ("cidZlJsMqb5eW3l6d9SuLvxOUX5wby+FqFIi79iEaKOEBc=", "\u80e1\u5ef6\u9a8f", True),
    ("cidjSSycmhW0mH7AF6r37qPb4mnRQNdLta7k5+R0uUdS80=", "\u90d1\u6653\u9633", True),
    ("cid//b2qSvLOHmTslqn3vsQEA==", "ISO27001/27701\u9879\u76ee\u4ea4\u6d41-\u4e1c\u65b9\u65e5\u5347", False),
    ("cidl0r3Jsck/mcpAlbWLJmm2Q==", "AKUO", False),
    ("cid61GnyvWzxo8F5VRy+MKEjQ==", "\u96c6\u56e2\u684c\u9762\u8fd0\u7ef4\u5bf9\u63a5\u7fa4", False),
    ("cidHzE2ZEVRpVmO1/kuCfjcTw==", "2026\u5e74\u5357\u6ee8\u57fa\u5730\u7533\u62a5\u56fd\u5bb6\u7ea7\u5353\u8d8a\u5de5\u5382\u9879\u76ee", False),
    ("cidyipjke68s0WdOyeF42Nn3YxxE2cH85o9uuzRdADnLUM=", "\u5218\u9e4f\u7a0b", True),
    ("cidzggawcH6tkmJzXsK3oZHHQ==", "\u6fb3\u6d32\u5b98\u7f51\u4fb5\u6743", False),
    ("cidVR2zYbC8/3L52RB7SBlWwQ==", "\u8054\u8f6f\u7ba1\u7406\u5e73\u53f0\u6c9f\u901a\u7fa4", False),
    ("cid2+8MtAeVMboNpxnGg7RlIA==", "523\u96c6\u56e2\u6218\u7565\u843d\u5730\u4f1a\u4e1a\u52a1\u95ee\u9898\u53cd\u9988\u8ddf\u8fdb", False),
    ("cidZGlQKb1dFBhkVGcZyy2N18JKP7sInFNkX45mwOoiNws=", "\u8c22\u82cf\u5dde", True),
    ("cide+AJ4tVQ48Y0Ro4SqGjlBQ==", "2026\u5e74\u80fd\u6e90\u6570\u667a\u4e2d\u5fc3\u7ec4\u7ec7\u7ee9\u6548\u76ee\u6807\u62c6\u89e3\u6c9f\u901a", False),
    ("cideBli2Aq4INtZyc8emBAJ6w==", "\u4fe1\u606f\u5b89\u5168\u65e5\u5e38\u4e8b\u4ef6\u6c9f\u901a", False),
    ("cidKzmNvC4YHCf3dimaRfJhLUX5wby+FqFIi79iEaKOEBc=", "\u4e01\u65ed\u4e1c", True),
    ("cidrzM9m9CBTamxHqK8pG96YQ==", "\u6d77\u5916NC\u63a8\u5e7f\u9a8c\u8bc1", False),
    ("cidu+KYRO0xodyuxfwFLthrTw==", "\u50a8\u80fd\u552e\u540e\u7cfb\u7edf\u90e8\u7f72\u8fc1\u79fb\u6c9f\u901a", False),
    ("cidqoBU4E8cXHuZ4p5VAknDOQ==", "\u57fa\u7840\u67b6\u6784", False),
    ("cid77pSbsS8yRq5L10zswbJpQ==", "\u3010\u4fe1\u606f\u5b89\u5168\u90e8\u3011\u5de5\u4f5c\u6c9f\u901a\u540c\u6b65\u7fa4", False),
    ("cid4/mSLd1wuZys64+/6+wT/Q==", "\u7b80\u9053\u4e91\u5f00\u53d1\u8005\u7fa4", False),
    # Page 2
    ("cidVzCweJSBOuq+8+/kOXT2PUX5wby+FqFIi79iEaKOEBc=", "\u6c6a\u5fb7\u5609 DJ Wang", True),
    ("cid5IEhOQ1pZGBKtPYzcG/fGXc3p3C5jjOZoO/VROOLIj8=", "\u738b\u817e\u5ddd", True),
    ("cid89aDTGKbEQvyqC56J3LFyUX5wby+FqFIi79iEaKOEBc=", "\u9648\u946b", True),
    ("cidr2ki/Eok0j+EIHAZrVnAPsJKP7sInFNkX45mwOoiNws=", "\u5f20\u5229\u82b3", True),
    ("cidjAMkcva6n2vHJYQKJsc+4MJKP7sInFNkX45mwOoiNws=", "\u674e\u5e7f\u4f1a", True),
    ("cidDGmAi0YESIbV1FMa97Si8kX5wby+FqFIi79iEaKOEBc=", "\u859b\u50b2\u6656", True),
    ("ciduS0xTQVrlcyvW6JzRXHRmsZR37obMA9tEPh+alPNE+4=", "\u6c60\u94ed\u822a", True),
    ("cid5mvpcLY3xHSMPEgxMmpduA==", "\u6b27\u6d32\u4e00\u4f53\u673a\u9879\u76ee\u4ea4\u4ed8\u6c9f\u901a\u7fa4", False),
    ("cidl1jYBheEv2LmVdJbvnRloA==", "2026\u5e74\u5b81\u6d77\u53bf\u6570\u5b57\u5316\u5e94\u7528\u8865\u8d34\u9879\u76ee", False),
    ("cidrI9jKm8p56wbdn0mpU+XJg==", "IT\u6b63\u7248\u5316\u5bf9\u5e94\u7fa4", False),
    ("cidmzsBej5c/2SBXpVh6OPW7Q==", "\u96c6\u56e2\u5b89\u5168\u6708\u5ea6\u62a5\u544a\u7248\u9762\u6837\u5f0f\u8bbe\u8ba1\u6c9f\u901a", False),
    ("cidf77oX9RM+Dpn02882j3AY0X5wby+FqFIi79iEaKOEBc=", "\u5c24\u8d5b\u8d5b", True),
    ("cidxYX4YU5hU1Vryau6zjXJmg==", "\u4e1c\u65b9\u65e5\u5347\u7f51\u7edc\u4ea4\u6d41\u7fa4", False),
    # Page 3
    ("cidz40pVKERbhQ4T5FcXtzB9EX5wby+FqFIi79iEaKOEBc=", "\u5f20\u5146\u5fb7", True),
    ("cidlhhjbOABTt7/n6Rqk9ngxg==", "\u57fa\u5730\u4fe1\u606f\u5b89\u5168\u4ea4\u6d41\u7fa4", False),
    ("cidLd15R/hv8+KdaNGYrOLSd7OmlP+MnLD4Bx+2Vgnm0NE=", "\u4fde\u71d5\u83b9", True),
    ("cid7Y9mUEXelGQDkniVXu9IAQ==", "\u57fa\u5730\u7ecf\u7406s", False),
    ("cidXgz9B5AgoJ/s7lkm4suJ0w==", "\u4e1c\u65b9\u65e5\u5347\u65b0\u80fd\u6e90\u80a1\u4efd\u6709\u9650\u516c\u53f8\u7684\u4e1c\u65b9\u65e5\u5347\u5b98\u65b9\u7fa4", False),
    ("cidnDal5z8g5q67j4v66MrbeA==", "\u4e1c\u65b9\u65e5\u5347\u96c6\u56e2\u4fe1\u606f\u5b89\u5168\u73b0\u72b6\u76d8\u70b9", False),
    ("cid9nGFJHozjkEovKZq1Dr05EX5wby+FqFIi79iEaKOEBc=", "\u5510\u96e8\u73ca", True),
    ("cid7SsM7LTQl6ChOg7ZtEOy7EX5wby+FqFIi79iEaKOEBc=", "\u7ae0\u6bc5", True),
    ("cid+mnGDXH/yQHe5k/lVKdm2MJKP7sInFNkX45mwOoiNws=", "\u848b\u6602\u5d07", True),
    ("cidEjJWheZbsjVKHxo0uaKnTw==", "TMS\u670d\u52a1\u5668\u8fd0\u7ef4", False),
    ("cidPiE+HVAoxgTJQp+Rdf+m8EX5wby+FqFIi79iEaKOEBc=", "\u4f0d\u4fca\u6770", True),
    ("cid9BIp5oITxXe2/ofbsw1GI0X5wby+FqFIi79iEaKOEBc=", "\u9648\u9752\u9752", True),
]

# Process file pages 4+
all_convs = {}

# Add inline conversations
for cid, title, single in inline_convs:
    all_convs[cid] = {
        "convId": cid,
        "title": title,
        "singleChat": single,
        "source": "inline"
    }

# Add from file pages
search_files = sorted(glob.glob(os.path.join(BASE, "_search_page*.json")))
for sf in search_files:
    try:
        with open(sf, "r", encoding="utf-8") as f:
            d = json.load(f)
        convs = d["result"]["conversationMessagesList"]
        for c in convs:
            cid = c["openConversationId"]
            if cid not in all_convs:
                all_convs[cid] = {
                    "convId": cid,
                    "title": c["title"],
                    "singleChat": c["singleChat"],
                    "source": os.path.basename(sf)
                }
    except Exception as e:
        print(f"Error: {e}")

# Save all conversations
out_file = os.path.join(BASE, "_all_convs.json")
conv_list = list(all_convs.values())
with open(out_file, "w", encoding="utf-8") as f:
    json.dump(conv_list, f, ensure_ascii=False, indent=2)

print(f"Total unique conversations: {len(conv_list)}")
print(f"  From inline: {len(inline_convs)}")
print(f"  From files: {len(conv_list) - len([c for c in conv_list if c['source']=='inline'])}")

# Also save a simple list of convIds for batch processing
ids_file = os.path.join(BASE, "_conv_ids.txt")
with open(ids_file, "w", encoding="utf-8") as f:
    for c in conv_list:
        f.write(f"{c['convId']}\t{c['title']}\t{c['singleChat']}\n")

print(f"Saved to {out_file} and {ids_file}")
