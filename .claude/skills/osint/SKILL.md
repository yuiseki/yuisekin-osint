---
name: osint
version: 1.0.0
description: セキュリティディフェンスのための OSINT（Open Source Intelligence）調査スキル。IP・ドメイン・ASN・サブドメインの調査を行う。「OSINT」「調査」「IP調べて」「ドメイン調べて」「このサイト何？」と言われたら使用する。
license: MIT
tags:
  - osint
  - security
  - reconnaissance
---

# OSINT 調査スキル

セキュリティディフェンスのための passive OSINT ワークフロー。

## 利用可能ツール

| ツール | コマンド | 用途 |
|---|---|---|
| whois | `whois example.com` | ドメイン登録情報 |
| dig | `dig example.com ANY` | DNS レコード全取得 |
| nslookup | `nslookup example.com` | DNS 簡易確認 |
| nmap | `nmap -sV -T4 example.com` | ポートスキャン・サービス検出 |
| subfinder | `subfinder -d example.com -silent` | サブドメイン列挙 |
| mtr | `sudo /opt/homebrew/sbin/mtr --report example.com` | ネットワーク経路診断 |
| geoip2fast | `geoip2fast 1.1.1.1` | GeoIP ルックアップ |
| ipinfo.io | `curl -s https://ipinfo.io/1.1.1.1 \| jq` | IP 情報（ASN, org, loc） |
| asn (Docker) | `docker run -it nitefood/asn 1.1.1.1` | ASN 詳細・BGP 経路 |
| curl + jq | 各種 API | HTTP ベースの調査 |

## 調査ワークフロー

### IP アドレスを調べる

```bash
# 1. 基本情報
curl -s "https://ipinfo.io/$IP" | jq

# 2. GeoIP
geoip2fast $IP

# 3. 逆引き DNS
dig -x $IP +short

# 4. ポートスキャン（許可がある場合のみ）
nmap -sV -T4 --top-ports 100 $IP
```

### ドメインを調べる

```bash
# 1. WHOIS
whois $DOMAIN

# 2. DNS レコード
dig $DOMAIN ANY +noall +answer
dig $DOMAIN MX +short
dig $DOMAIN TXT +short
dig $DOMAIN NS +short

# 3. IP アドレス解決
dig $DOMAIN A +short
dig $DOMAIN AAAA +short

# 4. サブドメイン列挙
subfinder -d $DOMAIN -silent

# 5. ネットワーク経路
sudo /opt/homebrew/sbin/mtr --report -c 10 $DOMAIN
```

### Web サイトを調べる

```bash
# 1. HTTP ヘッダ確認
curl -sI "https://$DOMAIN" | head -20

# 2. TLS 証明書
echo | openssl s_client -connect $DOMAIN:443 -servername $DOMAIN 2>/dev/null | openssl x509 -noout -subject -issuer -dates

# 3. リダイレクト追跡
curl -sLI "https://$DOMAIN" | grep -E "^(HTTP|Location)"

# 4. DNS + WHOIS + サブドメインを一括
dig $DOMAIN A +short && whois $DOMAIN | grep -E "Registrar|Creation|Expir|Name Server" && subfinder -d $DOMAIN -silent | head -20
```

### ASN / BGP 調査

```bash
# ASN ツール（Docker）
docker run -it nitefood/asn $IP_OR_ASN

# または curl で
curl -s "https://ipinfo.io/$IP" | jq '{ip, org, city, region, country}'
```

## 注意事項

- **passive OSINT のみ**。Active scan（nmap 等）は対象の許可がある場合のみ実行
- nmap はデフォルトで `-T4`（aggressive timing）を使うが、対象に負荷をかけすぎないよう注意
- Docker の asn ツールは初回起動が遅い（イメージ pull）

## セットアップ

```bash
# macOS
brew bundle --file=Brewfile

# Docker（asn ツール用）
docker pull nitefood/asn
```
