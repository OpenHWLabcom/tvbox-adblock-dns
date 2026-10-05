#!/usr/bin/env python3
# 给 AdGuard Home 添加 http 广告过滤列表
import urllib.request, json, base64, sys
pw = sys.argv[1] if len(sys.argv) > 1 else "OpenHWLab2026"
auth = base64.b64encode(("admin:" + pw).encode()).decode()
H = {"Content-Type": "application/json", "Authorization": "Basic " + auth}
base = "http://127.0.0.1:3000"

def post(p, o):
    r = urllib.request.urlopen(urllib.request.Request(base + p, data=json.dumps(o).encode(), headers=H), timeout=90)
    return r.status, r.read()[:120].decode("utf-8", "ignore")

filters = [
    ("http://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus&showintro=0&mimetype=plaintext", "yoyo-adservers"),
    ("http://someonewhocares.org/hosts/zero/hosts", "someonewhocares-hosts"),
]
for url, name in filters:
    try:
        print(name, post("/control/filtering/add_url", {"name": name, "url": url, "whitelist": False}))
    except Exception as e:
        print(name, "ERR", e)
try:
    print("refresh", post("/control/filtering/refresh", {"whitelist": False}))
except Exception as e:
    print("refresh ERR", e)
st = json.loads(urllib.request.urlopen(urllib.request.Request(base + "/control/filtering/status", headers=H), timeout=20).read())
print("enabled:", st.get("enabled"), "| rules:", st.get("rules_count"), "| filters:", [(f["name"], f["rules_count"]) for f in st.get("filters", [])])
