---
name: osint-person
version: 1.0.0
description: セキュリティディフェンス目的の人物 OSINT 調査スキル（広義 OSINT）。氏名・メールアドレス・ハンドルネームを入力に公開情報からオンライン足跡を集約する。「人物調査」「このハンドル誰？」「メールで調べて」「自分のデジタル足跡確認」と言われたら使用する。
license: MIT
tags:
  - osint
  - people
  - security
  - reconnaissance
---

# 人物 OSINT 調査スキル

広義 OSINT のうち、人物に紐づく公開情報を集約するワークフロー。想定用途:

- 社員・役員の公開情報監査（social engineering 耐性チェック）
- 自分自身のデジタル足跡確認（self-doxing check）
- インシデント対応での attacker 足取り追跡

**前提: 対象者本人の同意または業務上の正当な目的がある場合のみ使用する。** 個人情報保護法・GDPR に抵触する可能性がある。

## 利用可能ツール

| ツール | 入力 | 出力 | 無料枠 |
|---|---|---|---|
| Maigret | username | 3000+ サイトの profile 存在確認 | 完全無料 |
| Mosint | email | 登録サービス・breach・SMTP 検証 | 無料枠で動作 |
| GHunt | email (Gmail) | Google 生態系（Gaia ID, photos, reviews） | Google Cookie 必要 |
| theHarvester | domain / name | 公開情報 aggregator | 完全無料 |
| HaveIBeenPwned (Web) | email | データ漏洩チェック | Web 版は無料 |

月1回・1人調査想定なら HIBP は Web 版で十分。

## セットアップ

Docker でビルドして shell に入る:

```bash
make build-person
make shell-person
```

コンテナ内で各ツールが PATH に入っている。`/reports` ディレクトリは host の `./osint-reports/` にマウントされる。

### GHunt の初期設定（初回のみ）

GHunt は Google アカウント Cookie が必要。**本人のアカウントは使わず、調査専用の捨てアカウントを作る。**

```bash
make ghunt-login
# ブラウザ拡張 (GHunt Companion) または手動で master cookie を貼り付け
```

Cookie は `yuisekin-osint-ghunt` named volume に永続化される。

## 調査ワークフロー（コンテナ内で実行）

### ハンドルネーム調査

```bash
TARGET=octocat
OUT=/reports/$(date +%Y%m%d)-$TARGET
mkdir -p $OUT
maigret $TARGET --html --pdf --folderoutput $OUT
```

レポートは host 側の `./osint-reports/<date>-<target>/` に出力される。

### メールアドレス調査

```bash
EMAIL=target@example.com
USERNAME=$(echo $EMAIL | cut -d@ -f1)
OUT=/reports/$(date +%Y%m%d)-$USERNAME
mkdir -p $OUT

# 1. Mosint で登録サービス特定
mosint -e $EMAIL -o $OUT/mosint.json

# 2. Gmail なら GHunt で Google 生態系
ghunt email $EMAIL --json $OUT/ghunt.json

# 3. HaveIBeenPwned は Web でチェック
#    https://haveibeenpwned.com/account/<email>

# 4. ローカル部分を Maigret へ
maigret $USERNAME --html --folderoutput $OUT
```

### 氏名調査

```bash
FIRST=john
LAST=doe

# ハンドルネーム候補を展開して横断チェック
for handle in $FIRST$LAST $LAST$FIRST $FIRST.$LAST $FIRST-$LAST ${FIRST:0:1}$LAST $LAST${FIRST:0:1}; do
  echo "=== $handle ==="
  maigret $handle --timeout 10 --top-sites 100
done

# ドメインが判明しているなら theHarvester で org 単位
theHarvester -d example.com -b all -l 500 -f /reports/$(date +%Y%m%d)-theharvester
```

LinkedIn / X / Qiita / Zenn 等ログイン必須サイトは手動確認（閲覧のみ、足跡を残さない）。

## 注意事項

- passive OSINT のみ。対象者に通知が行く操作は避ける
- GHunt は調査専用の捨て Google アカウントで運用
- Mosint の一部モジュールはパスワードリセット要求を送る可能性あり。`mosint --help` で確認
- レポートファイルは外部に漏らさない。調査終了後は削除または暗号化保管
- `osint-reports/` は `.gitignore` に含まれている

## 法務リスク早見表

| 行為 | リスク |
|---|---|
| 公開プロフィールの閲覧 | 低 |
| 複数サイトの情報を集約 | 中（目的次第で「プロファイリング」に該当しうる） |
| 漏洩 DB の参照 | 中〜高（有料 DB は業務目的を明確化） |
| 本人への pretext コンタクト | 高（社内承認・契約がある場合のみ） |

## 補遺: SpiderFoot

より包括的な自動調査:

```bash
docker run --rm -it -p 5001:5001 ghcr.io/smicallef/spiderfoot:latest
# http://localhost:5001
```

200+ モジュールだが重量級。月1回1人想定なら本編ツール群で十分。

## 廃止候補

- **holehe**: パスワードリセット挙動検出方式。各サービスの対策で壊れがち。最終更新 2023。Mosint で代替
- **mailsleuth**: 開発停滞
