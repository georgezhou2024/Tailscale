# iStoreOS Tailscale 远程访问配置指南

在 iStoreOS (OpenWrt 24.10 x86_64) 上通过 Tailscale 实现安全远程访问 LuCI 后台。

## 环境信息

| 项目 | 信息 |
|------|------|
| 系统 | iStoreOS 24.10.8 (OpenWrt) |
| 架构 | x86_64 |
| 包管理 | opkg |
| 路由器 IP | 192.168.100.1 |
| Tailscale 版本 | 1.80.3-r1 |

## 安装步骤

### 1. 通过终端安装 Tailscale

SSH 或 Web 终端 (ttyd) 登录路由器后执行：

```bash
# 直接从 OpenWrt 官方源安装（24.10 已包含 tailscale）
opkg update
opkg install tailscale
```

> 如果官方源没有，可添加 Tailscale 官方源：
> ```bash
> cd /tmp
> curl -LO https://pkgs.tailscale.com/stable/opkg-repo-key.gpg
> opkg-key add opkg-repo-key.gpg
> echo "src/gz tailscale https://pkgs.tailscale.com/stable/openwrt-24.10/x86_64" >> /etc/opkg/customfeeds.conf
> opkg update
> opkg install tailscale
> ```

### 2. 启动 Tailscale 服务

```bash
/etc/init.d/tailscale enable
/etc/init.d/tailscale start
```

### 3. 登录授权

```bash
tailscale up --hostname=iStoreOS --accept-routes
```

终端会输出一个登录链接，类似：

```
To authenticate, visit:
    https://login.tailscale.com/a/xxxxxxxxxxxx
```

在浏览器打开这个链接，用 Google/GitHub/微软账号登录 Tailscale，点 **Connect** 授权。

看到 **Login successful** 页面就说明路由器已加入 Tailscale 网络。

### 4. 查看 Tailscale IP

```bash
tailscale ip -4
```

输出类似 `100.x.x.x`，这就是你的路由器 Tailscale 地址。

## 防火墙配置（关键！）

安装完后默认防火墙会挡住 Tailscale 访问 LuCI，必须加规则：

### 方法一：把 tailscale0 加入 LAN 区域

```bash
uci add_list firewall.@zone[0].network='tailscale0'
uci commit firewall
/etc/init.d/firewall restart
```

### 方法二：直接放行 HTTP 端口（实测有效）

```bash
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-Tailscale-HTTP'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].dest_port='80'
uci set firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].target='ACCEPT'
uci commit firewall
/etc/init.d/firewall restart
```

## 使用方法

1. 在手机/电脑上安装 Tailscale 客户端
2. 登录同一个 Tailscale 账号
3. 浏览器打开 `http://100.x.x.x`（路由器的 Tailscale IP）
4. 输入 LuCI 密码即可管理

## 常见问题

### 登录成功但网页打不开

检查防火墙是否放行：

```bash
# 确认 tailscale0 接口存在
ip addr show tailscale0

# 确认 uhttpd 监听所有接口
netstat -tlnp | grep :80
# 应该看到 0.0.0.0:80

# 从路由器本机测试
curl -sI http://100.x.x.x
# 应该返回 200 OK
```

### 手机显示 Connected 但访问不了

- 确认手机浏览器输入的是 `http://` 不是 `https://`
- 确认 Tailscale App 状态是 active 而不是 idle/offline
- 在路由器终端执行 `tailscale status` 看手机是否在线

### 设备数量限制

免费版 Tailscale 最多 3 台设备。在 https://login.tailscale.com/admin/machines 可以删除不用的设备。

## 相关项目

- [luci-app-ups-manager](https://github.com/liuyuhao1023/luci-app-ups-manager) — UPS 电源管理插件
- [Tailscale 官网](https://tailscale.com)
