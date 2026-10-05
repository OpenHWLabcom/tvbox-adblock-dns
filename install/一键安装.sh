#!/bin/bash
# ============================================================
#  OpenHW Lab · 机顶盒变「去广告 DNS 盒子」—— 一键安装（在电脑上跑）
#  用法：  ./一键安装.sh <盒子IP> [管理员密码]
#  前提：  盒子已 root、已开 ADB、电脑装了 adb、同一局域网；
#          盒子已建好 Linux 子系统 /data/linux。
#  作用：  识别架构 → 在电脑下载 AdGuard Home → 推进子系统 → 提示配置。
# ============================================================
set -e
IP="$1"; PW="${2:-OpenHWLab2026}"
[ -z "$IP" ] && { echo "用法: $0 <盒子IP> [管理员密码]"; exit 1; }
HERE="$(cd "$(dirname "$0")" && pwd)"
R=/data/linux
say(){ echo -e "\n\033[1;36m==> $*\033[0m"; }

say "连接盒子 $IP:5555"; adb connect "${IP}:5555"; adb wait-for-device
say "检查子系统"; adb shell "[ -d $R/root ] || { echo '未找到 $R（先按教程搭好 Linux 子系统）'; exit 1; }"

say "识别盒子架构"
ARCH=$(adb shell getprop ro.product.cpu.abi | tr -d '\r'); echo "  abi=$ARCH"
case "$ARCH" in *64*) A=arm64;; *) A=armv7;; esac
BIN="AdGuardHome_linux_${A}.tar.gz"

say "准备 AdGuard Home（$A）"
if [ -f "$HERE/$BIN" ]; then
  adb push "$HERE/$BIN" $R/root/adg.tgz
else
  echo "  未找到 $HERE/$BIN"
  echo "  请在电脑（有 https）下载后放到本目录："
  echo "    https://github.com/AdguardTeam/AdGuardHome/releases  → $BIN"
  echo "  然后再跑一次本脚本。"
fi

say "推配置脚本到子系统"
for f in adg_setup.py adg_upstream.py adg_filters.py; do
  [ -f "$HERE/$f" ] && adb push "$HERE/$f" $R/root/$f
done

say "在子系统里解压并首次启动"
cat <<EOF
  adb shell "busybox chroot $R /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin /bin/bash -c 'cd /root && tar xzf adg.tgz && cd AdGuardHome && nohup ./AdGuardHome >/root/adg.log 2>&1 &'"
EOF

say "配置（在电脑上跑；走 ssh 到盒子子系统更顺）"
echo "  python3 /root/adg_setup.py    $PW     # 首次配置: dns:53 / web:3000"
echo "  python3 /root/adg_upstream.py $PW     # ⭐ 上游改 TCP(关键)"
echo "  python3 /root/adg_filters.py  $PW     # 加 http 过滤列表"

say "完成！管理页 http://$IP:3000/ ；再把路由器 DHCP 的 DNS 指向 $IP，全家去广告"
