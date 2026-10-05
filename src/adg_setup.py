#!/usr/bin/env python3
# 配置 AdGuard Home（首次安装）：web :3000 / dns :53 / 管理员
import urllib.request, json, sys
pw = sys.argv[1] if len(sys.argv) > 1 else "OpenHWLab2026"
body = json.dumps({"web": {"ip": "0.0.0.0", "port": 3000},
                   "dns": {"ip": "0.0.0.0", "port": 53},
                   "username": "admin", "password": pw}).encode()
req = urllib.request.Request("http://127.0.0.1:3000/control/install/configure",
                             data=body, headers={"Content-Type": "application/json"})
try:
    r = urllib.request.urlopen(req, timeout=15)
    print("HTTP", r.status, r.read()[:200].decode("utf-8", "ignore"))
except Exception as e:
    print("ERR", e)
