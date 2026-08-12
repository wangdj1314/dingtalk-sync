import urllib.request, json, os, re, unicodedata

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pinyin_dict.json")
URL = "https://raw.githubusercontent.com/mozillazg/pinyin-data/master/kMandarin.txt"

def de_tone(s):
    # 去掉声调符号（如 qiū -> qiu）
    n = unicodedata.normalize("NFD", s)
    return "".join(c for c in n if unicodedata.combining(c) == 0).lower()

def main():
    req = urllib.request.Request(URL, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=60) as r:
        txt = r.read().decode("utf-8", "ignore")
    d = {}
    for line in txt.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            continue
        cp, rest = line.split(":", 1)
        cp = cp.strip()
        if not cp.startswith("U+"):
            continue
        py = rest.split("#")[0].strip().split()[0] if rest.split("#")[0].strip() else ""
        py = de_tone(py)
        if not re.match(r"^[a-z]+$", py):
            continue
        try:
            ch = chr(int(cp[2:], 16))
        except ValueError:
            continue
        if ch not in d:
            d[ch] = py
    with open(OUT, "w", encoding="utf-8") as f:
        json.dump(d, f, ensure_ascii=False, separators=(",", ":"))
    print("chars:", len(d), "size:", os.path.getsize(OUT))
    for t in ["王", "组", "负", "责", "人", "群", "李", "张", "日", "升"]:
        print(t, "->", d.get(t))

if __name__ == "__main__":
    main()
