机顶盒变「去广告 DNS 盒子」—— 安装文件说明
============================================

【一键安装.sh】 在电脑上跑： ./一键安装.sh <盒子IP> [管理员密码]
  作用：识别盒子架构 → 在电脑下载对应 AdGuard Home → 推进子系统 → 提示后续配置。
  前提：盒子已 root、已开 ADB、电脑装了 adb、同一局域网、子系统已搭好。

【adg_setup.py】  首次配置：web :3000 / dns :53 / 管理员账号密码（免网页向导）
  用法（在电脑上，走 ssh 或 adb shell 到子系统）：python3 adg_setup.py <密码>

【adg_upstream.py】 ⭐ 把上游 DNS 改成 tcp://（老盒子 UDP 被封，不改会解析超时）
  用法：python3 adg_upstream.py <密码>

【adg_filters.py】  添加 http 广告过滤列表（默认列表是 https，老盒子下不了）
  用法：python3 adg_filters.py <密码>

【3-开机自启.sh】  子系统里拉起 AdGuard Home（幂等），并入 /root/startbox.sh 之类。
【4-开机兜底.sh】  盒子侧(Android)挂载子系统 + 调启动脚本（模板）。

安装步骤详见 上级目录的【安装教程.pdf】。
