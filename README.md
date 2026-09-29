<p align="center">
  <img src="logo.png" alt="iStoreOS Tailscale" width="200">
</p>

# iStoreOS Tailscale 杩滅▼璁块棶閰嶇疆鎸囧崡

鍦?iStoreOS (OpenWrt 24.10 x86_64) 涓婇€氳繃 Tailscale 瀹炵幇瀹夊叏杩滅▼璁块棶 LuCI 鍚庡彴銆?
涓嶉渶瑕佸叕缃?IP锛屼笉闇€瑕?IPv6锛屼笉闇€瑕佺鍙ｈ浆鍙戯紝鍦ㄤ换浣曠綉缁滅幆澧冧笅閮借兘杩炲洖瀹躲€?
## 鐜淇℃伅

| 椤圭洰 | 淇℃伅 |
|------|------|
| 绯荤粺 | iStoreOS 24.10.8 (OpenWrt) |
| 鏋舵瀯 | x86_64 |
| 鍖呯鐞?| opkg |
| 璺敱鍣?IP | 192.168.100.1 |
| Tailscale 鐗堟湰 | 1.80.3-r1 |

---

## 涓€銆佽矾鐢卞櫒绔畨瑁?
### 涓€閿畨瑁咃紙鎺ㄨ崘锛?
SSH 鎴?Web 缁堢 (ttyd) 鐧诲綍璺敱鍣ㄥ悗锛岀洿鎺ヨ繍琛岋細

```bash
wget https://raw.githubusercontent.com/georgezhou2024/Tailscale/main/tailscale-setup.sh
sh tailscale-setup.sh
```

鑴氭湰鑷姩瀹屾垚锛氬畨瑁?Tailscale 鈫?鍚姩鏈嶅姟 鈫?閰嶇疆闃茬伀澧欐斁琛?80/2026 绔彛 鈫?鐢熸垚鐧诲綍閾炬帴銆?璺熺潃鎻愮ず鍦ㄦ祻瑙堝櫒鎵撳紑閾炬帴鎺堟潈鍗冲彲銆?
---

### 鎵嬪姩瀹夎

SSH 鎴?Web 缁堢 (ttyd锛屽湴鍧€ `http://192.168.100.1:7681`) 鐧诲綍璺敱鍣ㄥ悗鎵ц锛?
```bash
opkg update
opkg install tailscale
```

> 濡傛灉瀹樻柟婧愭病鏈夛紝鍙坊鍔?Tailscale 瀹樻柟婧愶細
> ```bash
> cd /tmp
> curl -LO https://pkgs.tailscale.com/stable/opkg-repo-key.gpg
> opkg-key add opkg-repo-key.gpg
> echo "src/gz tailscale https://pkgs.tailscale.com/stable/openwrt-24.10/x86_64" >> /etc/opkg/customfeeds.conf
> opkg update
> opkg install tailscale
> ```

#### 鍚姩 Tailscale 鏈嶅姟

```bash
/etc/init.d/tailscale enable
/etc/init.d/tailscale start
```

#### 鐧诲綍鎺堟潈

```bash
tailscale up --hostname=iStoreOS --accept-routes
```

缁堢浼氳緭鍑轰竴涓櫥褰曢摼鎺ワ細

```
To authenticate, visit:
    https://login.tailscale.com/a/xxxxxxxxxxxx
```

鍦ㄦ祻瑙堝櫒鎵撳紑杩欎釜閾炬帴锛岀敤 Google/GitHub/寰蒋璐﹀彿鐧诲綍 Tailscale锛岀偣 **Connect** 鎺堟潈銆?
鐪嬪埌 **Login successful** 椤甸潰灏辫鏄庤矾鐢卞櫒宸插姞鍏ョ綉缁溿€?
### 4. 鏌ョ湅璺敱鍣?Tailscale IP

```bash
tailscale ip -4
```

杈撳嚭绫讳技 `100.x.x.x`锛岃涓嬫潵锛屼互鍚庣敤杩欎釜鍦板潃璁块棶璺敱鍣ㄣ€?
---

## 浜屻€侀槻鐏閰嶇疆锛堝叧閿紒涓嶅仛杩欐缃戦〉鎵撲笉寮€锛?
鏀捐 80 绔彛锛圠uCI锛夊拰 2026 绔彛锛圤pen-Box 闈㈡澘锛夛細

```bash
# 鏀捐 80 绔彛锛圠uCI 鍚庡彴锛?uci add firewall rule
uci set firewall.@rule[-1].name='Allow-Tailscale-HTTP'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].dest_port='80'
uci set firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].target='ACCEPT'

# 鏀捐 2026 绔彛锛圤pen-Box 闈㈡澘锛?uci add firewall rule
uci set firewall.@rule[-1].name='Allow-Tailscale-2026'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].dest_port='2026'
uci set firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].target='ACCEPT'

uci commit firewall
/etc/init.d/firewall restart
```

---

## 涓夈€佹墜鏈虹璁剧疆

### 鑻规灉鎵嬫満 (iPhone)

1. App Store 鎼滅储 **Tailscale** 涓嬭浇瀹夎
2. 鎵撳紑 App锛岀櫥褰曞悓涓€涓?Tailscale 璐﹀彿
3. 寮圭獥璇锋眰 VPN 鏉冮檺锛岀偣 **鍏佽**
4. 纭寮€鍏虫槸 **Connected**锛堣摑鑹诧級
5. 鎵撳紑 Safari锛岃緭鍏?`http://100.x.x.x:2026`锛圤pen-Box 闈㈡澘锛?6. 杈撳叆瀵嗙爜鍗冲彲绠＄悊

### 瀹夊崜鎵嬫満

1. 搴旂敤鍟嗗簵鎼滅储 **Tailscale** 涓嬭浇瀹夎
2. 鎵撳紑 App锛岀櫥褰曞悓涓€涓?Tailscale 璐﹀彿
3. 鍏佽 VPN 杩炴帴鏉冮檺
4. 纭寮€鍏虫槸 **Connected**
5. 鎵撳紑娴忚鍣紝杈撳叆 `http://100.x.x.x:2026`

---

## 鍥涖€佺數鑴戠璁剧疆

### Windows

1. 鎵撳紑 https://tailscale.com/download/windows 涓嬭浇瀹夎
2. 鐧诲綍鍚屼竴涓?Tailscale 璐﹀彿
3. 绯荤粺鎵樼洏鍑虹幇 Tailscale 鍥炬爣锛岀‘璁ゅ凡杩炴帴
4. 娴忚鍣ㄨ緭鍏?`http://100.x.x.x:2026`

### Mac

1. 鎵撳紑 App Store 鎼滅储 **Tailscale** 瀹夎
2. 鐧诲綍鍚屼竴涓处鍙?3. 娴忚鍣ㄨ緭鍏?`http://100.x.x.x:2026`

---

## 浜斻€佹坊鍔犳柊璁惧

1. 鍦ㄦ柊璁惧涓婂畨瑁?Tailscale 瀹㈡埛绔?2. 鐧诲綍鍚屼竴涓?Tailscale 璐﹀彿
3. 鑷姩鍔犲叆缃戠粶锛屼笉闇€瑕佸湪璺敱鍣ㄤ笂鍋氫换浣曟搷浣?4. 鍦ㄦ墜鏈?鐢佃剳涓婄敤 `http://100.x.x.x:2026` 璁块棶 Open-Box 闈㈡澘

> 娉ㄦ剰锛氬厤璐圭増鏈€澶?3 鍙拌澶囥€?
---

## 鍏€佸垹闄よ澶?
1. 鎵撳紑 https://login.tailscale.com/admin/machines
2. 鎵惧埌瑕佸垹闄ょ殑璁惧
3. 鐐瑰彸杈?`...` 鈫?**Remove**
4. 纭鍒犻櫎

鍒犻櫎鍚庤璁惧灏变笉鑳藉啀杩炲洖浣犵殑璺敱鍣ㄤ簡銆?
---

## 甯歌闂

### 鐧诲綍鎴愬姛浣嗙綉椤垫墦涓嶅紑

```bash
# 纭 tailscale0 鎺ュ彛瀛樺湪
ip addr show tailscale0

# 纭 uhttpd 鐩戝惉鎵€鏈夋帴鍙?netstat -tlnp | grep :80
# 搴旇鐪嬪埌 0.0.0.0:80

# 浠庤矾鐢卞櫒鏈満娴嬭瘯
curl -sI http://100.x.x.x
# 搴旇杩斿洖 200 OK
```

### 鎵嬫満鏄剧ず Connected 浣嗚闂笉浜?
- 纭娴忚鍣ㄨ緭鍏ョ殑鏄?`http://` 涓嶆槸 `https://`
- 鍦ㄨ矾鐢卞櫒缁堢鎵ц `tailscale status` 鐪嬫墜鏈烘槸鍚︽樉绀?**active**
- 濡傛灉鏄剧ず **idle/offline**锛屾妸鎵嬫満 Tailscale App 鍏虫帀閲嶅紑

### 涓嶉渶瑕佸叕缃?IP / IPv6

Tailscale 鑷姩鎵撴礊锛屾墦涓嶉€氬氨璧颁腑缁ф湇鍔″櫒锛屼换浣曠綉缁滅幆澧冮兘鑳界敤銆?
---

## 鐩稿叧椤圭洰

- [luci-app-ups-manager](https://github.com/liuyuhao1023/luci-app-ups-manager) 鈥?UPS 鐢垫簮绠＄悊鎻掍欢
- [Tailscale 瀹樼綉](https://tailscale.com)

