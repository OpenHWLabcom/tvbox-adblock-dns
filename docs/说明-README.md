# 说明 README —— 机顶盒变「去广告 DNS 盒子」(开发者)

## 组成

```
[手机/电视/电脑] --DNS:53--> AdGuard Home (在 chroot 子系统里)
                                 |  上游(走 TCP): tcp://223.5.5.5 / tcp://119.29.29.29 ...
                                 v
                            互联网 DNS
管理页: http://<盒子IP>:3000/  (admin / 你设的密码)
```

## 文件

| 文件 | 说明 |
|---|---|
| `adg_setup.py` | 首次配置：`POST /control/install/configure`（web:3000 / dns:53 / 管理员） |
| `adg_upstream.py` | `POST /control/dns_config`：上游改 `tcp://…`（老盒子 UDP 被封） |
| `adg_filters.py` | `POST /control/filtering/add_url`：加 http 过滤列表 |
| `3-开机自启.sh` (adgstart.sh) | 子系统启动：拉起 AdGuard Home（幂等） |
| `4-开机兜底.sh` | 盒子侧启动（挂子系统 + 调 adgstart） |
| `源码/` | 上述脚本 + AdGuard Home 下载/版本说明 |

## ⚠ 关键点
1. **上游必须 tcp://**：老盒子子系统 **UDP 被封锁**，DNS 默认走 UDP → 解析超时；改 TCP 才通。
2. **过滤列表用 http**：AdGuard 默认列表是 https，老盒子下不了 → 用 http 列表（pgl.yoyo.org / someonewhocares.org）。
3. **AdGuard 只有 https 下载**：在**电脑上**下好二进制再传进盒子。
4. 全家生效：把**路由器 DHCP 的 DNS** 指向盒子 IP；盒子上游/自身仍能上网（走 TCP）。

## AdGuard Home 版本
本教程实测 v0.107.79（linux_arm64）。armv7 盒子用 `AdGuardHome_linux_armv7.tar.gz`。

## 接口速查（AdGuard Home，Basic auth admin:密码）
- `POST /control/install/configure`  首次配置
- `GET/POST /control/dns_info|dns_config`  上游/引导 DNS
- `POST /control/filtering/add_url` · `GET /control/filtering/status` · `POST /control/filtering/refresh`
