#!/usr/bin/env python3
# 把 AdGuard Home 上游改为 TCP（盒子 UDP 被封）
import urllib.request, json, base64, sys
pw = sys.argv[1] if len(sys.argv) > 1 else "OpenHWLab2026"
auth = base64.b64encode(("admin:" + pw).encode()).decode()
H = {"Content-Type": "application/json", "Authorization": "Basic " + auth}
base = "http://127.0.0.1:3000"
cfg = json.loads(urllib.request.urlopen(urllib.request.Request(base + "/control/dns_info", headers=H), timeout=10).read())
cfg["upstream_dns"] = ["tcp://223.5.5.5", "tcp://119.29.29.29", "tcp://114.114.114.114"]
cfg["bootstrap_dns"] = ["223.5.5.5", "119.29.29.29"]
r = urllib.request.urlopen(urllib.request.Request(base + "/control/dns_config", data=json.dumps(cfg).encode(), headers=H), timeout=15)
print("dns_config ->", r.status)
