# 机顶盒变「去广告 DNS 盒子」· TV Box → Ad-blocking DNS (AdGuard Home)

> 闲置盒子 = 一台 24 小时的**局域网 DNS 服务器**：全家设备**自动去广告、防跟踪**，
> 一次配置、全屋生效（手机 / 电视 / 电脑都干净）。进阶可当"旁路由"。
> Idle TV box = a 24/7 **LAN DNS server** that blocks ads & trackers for every device at home.

---

## 🇨🇳 中文

### 功能
- **全屋去广告**：在 DNS 层拦掉广告/跟踪/钓鱼域名，所有设备自动生效（无需逐台装 App）
- **防跟踪 / 隐私**：挡掉统计埋点；可做**家长控制**（屏蔽网站/时段）
- **可视化**：AdGuard Home 管理页看查询量、**拦截比例**、拦截排行、每台设备
- **轻量**：AdGuard Home 单文件、资源占用低，很老的盒子也能跑
- **可选旁路由**：只做 DNS 是"去广告"；把网关也指向盒子可做分流/代理（进阶）

### 环境要求
- 已 **root** 的安卓机顶盒（Android 4.4+，armv7/arm64），能开 **ADB**
- 已搭好 Linux 子系统（chroot Ubuntu）
- 路由器能改 **DHCP 的 DNS**（指向盒子）

### 安装（要点）
```bash
cd install
./一键安装.sh <盒子IP> [管理员密码]     # 识别架构→下 AdGuard→推入子系统
python3 adg_setup.py    <密码>          # 首次配置: dns:53 / web:3000
python3 adg_upstream.py <密码>          # ⭐ 上游改 TCP（老盒子 UDP 被封，关键）
python3 adg_filters.py  <密码>          # 加 http 广告过滤列表
```
完整图文：**[`docs/安装教程.md`](docs/安装教程.md)**（另附 html/txt）

### 使用
- **管理页**：`http://<盒子IP>:3000/`（admin / 你的密码）
- **DNS**：`<盒子IP>:53` —— 把**路由器 DHCP 的 DNS** 改成盒子 IP → 全家去广告
- ⚠️ 盒子是 DNS 单点，路由器请设**备用 DNS**（如 223.5.5.5）

### 目录
```
install/   安装文件（一键安装.sh + 配置脚本 + 启动脚本）
src/       源码（配置脚本 adg_*.py + adgstart.sh）
docs/      教程与开发者文档
```

---

## 🇬🇧 English

### Features
- **Whole-home ad blocking** at the DNS layer — every device benefits, no per-device app
- **Anti-tracking / privacy**; optional **parental controls**
- **Dashboard**: query volume, **block ratio**, top blocked, per-device stats
- **Lightweight**: AdGuard Home is a single binary; runs on very old boxes
- **Optional bypass-router**: DNS-only = ad-blocking; also point the gateway at it for routing (advanced)

### Requirements
- A **rooted** Android TV box (Android 4.4+, armv7/arm64) with **ADB**
- A Linux subsystem (chroot Ubuntu) already set up
- A router whose **DHCP DNS** you can set (point it at the box)

### Install (key steps)
```bash
cd install
./一键安装.sh <box-ip> [admin-password]   # detect arch → fetch AdGuard → push into subsystem
python3 adg_setup.py    <pw>              # first-run config: dns:53 / web:3000
python3 adg_upstream.py <pw>              # ⭐ upstream over TCP (old boxes block UDP — critical)
python3 adg_filters.py  <pw>              # add http filter lists
```
Full illustrated guide: **[`docs/安装教程.md`](docs/安装教程.md)** (html/txt included)

### Usage
- **Admin**: `http://<box-ip>:3000/` (admin / your password)
- **DNS**: `<box-ip>:53` — set your **router's DHCP DNS** to the box → whole home blocked
- ⚠️ The box is a single point for DNS; set a **backup DNS** on the router

### Layout
```
install/   installer (one-click + config scripts + startup scripts)
src/       source (adg_*.py config scripts + adgstart.sh)
docs/      guides & dev docs
```

---

## License · 许可
[MIT](LICENSE) · 仅供学习与个人使用 / For learning and personal use only.

---

## 🔗 相关链接 · Links
- 官网 Website: https://www.openhwlab.com/
- 本项目 Project: https://github.com/OpenHWLabcom/tvbox-adblock-dns
- 姊妹项目 Siblings:
  [游戏机 Game Console](https://github.com/OpenHWLabcom/tvbox-game-console) ·
  [电脑主机 Mini PC](https://github.com/OpenHWLabcom/tvbox-desktop-pc) ·
  [监控录像 NVR](https://github.com/OpenHWLabcom/tvbox-surveillance) ·
  [打印机服务器 Print Server](https://github.com/OpenHWLabcom/tvbox-print-server) ·
  [下载机NAS Download Box + NAS](https://github.com/OpenHWLabcom/tvbox-nas-download)
- 官网源码 Website source: https://github.com/OpenHWLabcom/website
