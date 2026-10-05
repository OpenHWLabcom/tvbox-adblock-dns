#!/system/bin/sh
# OpenHW Lab · 去广告 DNS 盒子 —— 盒子侧(Android) 开机脚本（模板；幂等）
exec > /data/adg-boot.log 2>&1
echo "=== adguard autostart $(date) ==="
[ -e /data/no_autostart ] && { echo "no_autostart, skip"; exit 0; }

# 等系统启动完成
i=0
while [ $i -lt 60 ]; do
  [ "$(getprop sys.boot_completed)" = "1" ] && break
  sleep 2; i=$((i+1))
done
sleep 5

# 挂载 Linux 子系统（按你的盒子改：镜像路径 / 分区）
R=/data/linux
IMG=/storage/emulated/0/linux20.img
busybox mkdir -p $R
busybox losetup /dev/block/loop0 "$IMG" 2>/dev/null
busybox mount -t ext4 /dev/block/loop0 $R 2>/dev/null
busybox mount -t proc   proc   $R/proc 2>/dev/null
busybox mount -o bind   /dev   $R/dev  2>/dev/null
busybox mount -t devpts devpts $R/dev/pts 2>/dev/null
busybox mkdir -p $R/sdcard && busybox mount -o bind /storage/emulated/0 $R/sdcard 2>/dev/null
busybox mkdir -p $R/sys    && busybox mount -o bind /sys $R/sys 2>/dev/null
echo "mounted=$(busybox mount | busybox grep -c ' /data/linux ')"

# chroot 起 AdGuard Home（adgstart.sh 幂等）
busybox chroot $R /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin HOME=/root \
  /bin/sh /root/adgstart.sh >/data/adgstart.log 2>&1 </dev/null &
sleep 4
echo "=== done ==="
