#!/bin/sh
# ============================================================
# iStoreOS Tailscale 一键安装配置脚本
# 适用: iStoreOS 24.10+ / OpenWrt 24.10 x86_64
# 用法: sh tailscale-setup.sh
# ============================================================

set -e

echo "=========================================="
echo "  iStoreOS Tailscale 一键配置"
echo "=========================================="

# 1. 安装 Tailscale
echo ""
echo "[1/5] 安装 Tailscale..."
opkg update
opkg install tailscale

# 2. 启动并设置开机自启
echo ""
echo "[2/5] 启动 Tailscale 服务..."
/etc/init.d/tailscale enable
/etc/init.d/tailscale start

# 3. 防火墙放行 80 和 2026 端口
echo ""
echo "[3/5] 配置防火墙规则..."

# 检查是否已有规则，避免重复添加
if ! uci show firewall | grep -q "Allow-Tailscale-HTTP"; then
    uci add firewall rule
    uci set firewall.@rule[-1].name='Allow-Tailscale-HTTP'
    uci set firewall.@rule[-1].src='*'
    uci set firewall.@rule[-1].dest_port='80'
    uci set firewall.@rule[-1].proto='tcp'
    uci set firewall.@rule[-1].target='ACCEPT'
fi

if ! uci show firewall | grep -q "Allow-Tailscale-2026"; then
    uci add firewall rule
    uci set firewall.@rule[-1].name='Allow-Tailscale-2026'
    uci set firewall.@rule[-1].src='*'
    uci set firewall.@rule[-1].dest_port='2026'
    uci set firewall.@rule[-1].proto='tcp'
    uci set firewall.@rule[-1].target='ACCEPT'
fi

uci commit firewall
/etc/init.d/firewall restart

# 4. 登录授权
echo ""
echo "[4/5] 启动 Tailscale 登录授权..."
echo "请在浏览器打开下面的链接完成授权："
echo ""
tailscale up --hostname=iStoreOS --accept-routes

# 5. 显示结果
echo ""
echo "[5/5] 配置完成！"
echo "=========================================="
echo ""
echo "你的路由器 Tailscale IP 是："
tailscale ip -4
echo ""
echo "远程访问地址："
echo "  LuCI 后台:    http://\$(tailscale ip -4)"
echo "  Open-Box 面板: http://\$(tailscale ip -4):2026"
echo ""
echo "手机/电脑装 Tailscale 客户端，登录同一账号即可远程访问。"
echo "=========================================="
