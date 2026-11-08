# 医療法人補助金申請システム（架空の案件）

## 1. サービス概要

### 1.1 目的

全国の医療事業者を対象とした、国の補助金申請・審査業務をオンライン化するWebシステムとする。

### 1.2 利用者・提供機能

病院、診療所、その他の対象医療事業者の担当者に対し、以下の機能をオンラインで提供する。

- 補助金申請情報の入力
- 必要書類の提出
- 申請状況の確認

### 1.3 審査業務

行政機関および委託先の審査担当者が、以下の一連の業務をシステム上で実施できるものとする。

- 申請情報の確認
- 不備確認
- 差戻し
- 再申請
- 審査
- 承認

### 1.4 利用特性

補助金申請は年間を通して受け付ける。

四半期末および年度末等の締切時期には申請が集中し、通常時と比較してアクセス数および申請処理件数が大幅に増加することを想定する。

### 1.5 取扱情報

以下の重要情報を取り扱う。

- 事業者情報
- 担当者情報
- 申請内容
- 添付書類
- 審査結果

情報漏えい、不正アクセス、データ改ざん、長時間のサービス停止が発生した場合、事業運営への影響に加え、行政機関としての説明責任が生じる。

### 1.6 基本方針

以下を満たすシステム構成とする。

- 安定したサービス提供
- アクセス集中への対応
- 厳格なアクセス制御
- 操作・変更履歴の追跡
- 障害・セキュリティインシデント発生時の迅速な原因調査および復旧

---

## 2. サービスの前提条件

### 2.1 利用規模・利用特性

| 項目 | 前提条件 |
| --- | --- |
| 対象地域 | 日本全国（国内のみ） |
| 対象事業者 | 病院、診療所等の医療事業者 |
| 登録事業者数 | 約120,000事業者 |
| 登録ユーザー数 | 約300,000ユーザー |
| 通常時DAU | 約30,000人 |
| 繁忙期DAU | 約100,000人 |
| 通常時同時接続数 | 約1,000人 |
| ピーク時同時接続数 | 約10,000人 |
| 通常時リクエスト数 | 50～100 RPS |
| ピーク時リクエスト数 | 500～1,000 RPS |
| 主な利用時間 | 平日 8:00～20:00 |
| サービス提供時間 | 原則24時間365日 |
| アクセス集中時期 | 3月、6月、9月、12月の四半期末 |
| 繁忙期アクセス量 | 通常時の5～10倍程度を想定 |

※ RPS、ECSタスク数、Aurora ACU等は設計上の想定値とする。本番導入時には負荷試験を実施し、その結果を基にECSタスク数、Auto Scaling設定、Auroraキャパシティ等を調整する。

### 2.2 可用性

| 項目 | 前提条件 |
| --- | --- |
| 目標稼働率 | 99.9%以上 |
| AZ障害 | 単一AZに障害が発生した場合もサービスを継続できる構成とする |
| 目標復旧時間（RTO） | 1時間以内 |
| 目標復旧時点（RPO） | 5分以内 |
| データベース | Auroraの自動バックアップおよびPITRを利用する |
| 添付ファイル | S3 Versioningを有効化し、誤削除・上書きから復元可能とする |

### 2.3 バックアップ・復旧方針

Aurora MySQLでは自動バックアップおよびPITR（Point-in-Time Recovery）を利用し、障害発生直前に近い時点への復元を可能とすることで、RPO 5分以内を目標とする。

データ破損等が発生した場合は、PITRによって新しいAuroraクラスターを復元し、アプリケーションの接続先を切り替える。復旧手順を事前に整備し、RTO 1時間以内でのサービス復旧を目標とする。

添付書類を保存するS3バケットではVersioningを有効化し、誤削除や上書きが発生した場合に以前のバージョンへ復元できる構成とする。

---

## 3. システム構成

### 3.1 システム構成図
<img width="2352" height="1466" alt="aws_architecture_all_inside_cloud drawio20261027" src="https://github.com/user-attachments/assets/0b20fef5-9b22-4bbf-89fb-aadd7cb7ddea" />


### 3.2 主な構成

| 分類 | AWSサービス・技術 |
| --- | --- |
| コンピューティング | ECS Fargate / Service Auto Scaling |
| ネットワーク | VPC / Subnet / Security Group / Route 53 / CloudFront / ALB |
| 証明書 | ACM |
| データベース | Aurora MySQL（Serverless v2） |
| ストレージ | S3 / S3 Versioning |
| 管理者・運用者認証 | IAM Identity Center |
| セキュリティ | AWS WAF / GuardDuty / Security Hub / Inspector |
| 組織管理 | AWS Organizations |
| 機密情報・暗号化 | Secrets Manager / KMS |
| 監視・ログ | CloudWatch / CloudWatch Logs / CloudWatch Alarms |
| 監査・構成管理 | CloudTrail / AWS Config / アプリケーション監査ログ |
| 通知 | SNS / SES |
| コンテナレジストリ | ECR |
| CI/CD | GitHub Actions |
| IaC | Terraform |
| コスト管理 | AWS Budgets / AWS Cost Explorer |

### 3.3 可用性設計

ALBおよびECS Serviceを複数のAZにまたがって配置する。

ECS Serviceは複数タスクを複数AZに分散配置し、単一AZに障害が発生した場合でも残存AZでサービスを継続できる構成とする。

Aurora MySQLについても複数AZ構成とし、Writer障害時に別AZのReaderへフェイルオーバーできる構成とする。

### 3.4 スケーリング設計

ECS ServiceではService Auto Scalingを利用する。

通常時は必要最低限のタスク数で稼働させ、CPU使用率やALBのリクエスト数等を指標として、アクセス増加時にタスク数を自動的に増加させる。

Aurora MySQLではServerless v2を採用し、通常時と繁忙期の負荷変動に応じてDBキャパシティを調整できる構成とする。

具体的なAuto Scalingの閾値およびAuroraの最小・最大ACUについては、負荷試験結果を基に決定する。

### 3.5 セキュリティ・監査設計

各サービスを以下の目的で利用する。

| サービス | 目的 |
| --- | --- |
| AWS WAF | Webアプリケーションに対する攻撃の検知・遮断 |
| GuardDuty | AWS環境における不審なアクティビティや脅威の検知 |
| Inspector | EC2・ECR等の脆弱性管理 |
| Security Hub | セキュリティ検出結果・セキュリティ状態の集約 |
| CloudTrail | AWS API操作の監査 |
| AWS Config | AWSリソースの設定変更・構成履歴の管理 |
| KMS | 保存データ等の暗号化に利用する鍵の管理 |
| Secrets Manager | DB認証情報等の機密情報の管理 |

CloudTrailとは別に、申請・差戻し・審査・承認等の業務操作についてはアプリケーション側で監査ログを記録する。

監査ログには、操作者、操作日時、対象リソース、操作内容等を記録し、AWS上の操作履歴とアプリケーション上の業務操作履歴をそれぞれ追跡可能な構成とする。

---

## 4. コスト概算

> **注意:** 以下は設計時点における主要な固定・準固定費の概算値。実際の料金はリージョン、通信量、リクエスト数、負荷状況等によって変動する。

### 4.1 本番想定構成（1環境）

**前提：常時稼働**

| サービス | 月額概算 | 算出条件 |
| --- | ---: | --- |
| Aurora Serverless v2 | $382.61（約57,400円） | Aurora MySQL / Standard / On-Demand / 平均4 ACU / Storage 20GB / Backup 20GB |
| ECS Fargate | $179.94（約27,000円） | Linux x86 / 平均4タスク / 1 vCPU・2GB / 24時間稼働 / Ephemeral Storage 20GB |
| ALB | $20.66（約3,100円） | ALB × 1 / 24時間稼働 / LCU利用量を考慮 |
| NAT Gateway | $91.76（約13,800円） | NAT Gateway利用料およびデータ処理量を想定 |
| **合計** | **$674.97（約101,200円）** | **主要ワークロードサービスのみの概算** |

※ 1 USD = 150円で換算。  
※ 年間概算：約$8,099.64（約121.5万円）。  
※ CloudFront、WAF、S3、CloudWatch、Route 53、ECR、SES等は含まない。  
※ ECSタスク数およびAurora ACUは設計上の仮定であり、実際の負荷試験結果によって変更する。

---

## 5. 初期構築手順

以下はDEV環境の例とする。STG / PRODでは環境名およびAWSプロファイルを変更する。

### 5.1 Bootstrap

1. `environments/dev/bootstrap/terraform.tfvars` を設定する。
2. AWSへログインし、Terraform State用S3バケットおよびCI/CD用IAM Roleを作成する。

```bash
export AWS_PROFILE=dev-account

aws sso login --profile "$AWS_PROFILE"
aws sts get-caller-identity

terraform -chdir=environments/dev/bootstrap init
terraform -chdir=environments/dev/bootstrap plan
terraform -chdir=environments/dev/bootstrap apply

terraform -chdir=environments/dev/bootstrap output
