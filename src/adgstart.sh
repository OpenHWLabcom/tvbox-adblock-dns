#!/bin/sh
# OpenHW Lab · 去广告 DNS 启动脚本（在 Linux 子系统/chroot 里跑，幂等）
# 放到子系统 /root/adgstart.sh；由盒子开机脚本 chroot 调用。
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HOME=/root

# AdGuard Home：DNS :53 + 管理页 :3000
pgrep -f "[A]dGuardHome" >/dev/null || \
  ( cd /root/AdGuardHome && nohup ./AdGuardHome >/root/adg.log 2>&1 & )

sleep 1
echo "adguard: $(pgrep -c -f '[A]dGuardHome')"
