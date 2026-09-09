# 医療法人補助金申請システム

## 1. サービス概要

### 1.1 目的

全国の医療事業者を対象とした、国の補助金申請・審査業務をオンライン化するWebシステムとする。

### 1.2 利用者・提供機能

病院、診療所、その他の対象医療事業者の担当者に対し、以下の機能をオンラインで提供する。

* 補助金申請情報の入力
* 必要書類の提出
* 申請状況の確認

### 1.3 審査業務

行政機関および委託先の審査担当者が、以下の一連の業務をシステム上で実施できるものとする。

* 申請情報の確認
* 不備確認
* 差戻し
* 再申請
* 審査
* 承認

### 1.4 利用特性

補助金申請は年間を通して受け付ける。

四半期末および年度末等の締切時期には申請が集中し、通常時と比較してアクセス数および申請処理件数が大幅に増加することを想定する。

### 1.5 取扱情報

以下の重要情報を取り扱う。

* 事業者情報
* 担当者情報
* 申請内容
* 添付書類
* 審査結果

情報漏えい、不正アクセス、データ改ざん、長時間のサービス停止が発生した場合、事業運営への影響に加え、行政機関としての説明責任が生じる。

### 1.6 基本方針

以下を満たすシステム構成とする。

* 安定したサービス提供
* アクセス集中への対応
* 厳格なアクセス制御
* 操作・変更履歴の追跡
* 障害発生時の原因調査および復旧
* セキュリティインシデント発生時の原因調査および復旧

---

## 2. システム構成

### 2.1 システム構成図

> **TODO:** システム構成図を挿入

### 2.2 主な構成

| 分類        | AWSサービス・技術                                                  |
| --------- | ----------------------------------------------------------- |
| コンピューティング | ECS Fargate / Service Auto Scaling                          |
| ネットワーク    | VPC / Subnet / Security Group / Route 53 / CloudFront / ALB |
| 証明書       | ACM                                                         |
| データベース    | Aurora MySQL                                                |
| ストレージ     | S3                                                          |
| 認証        | Cognito / IAM Identity Center                               |
| セキュリティ    | AWS WAF / GuardDuty / Security Hub / Inspector              |
| 組織管理      | AWS Organizations                                           |
| 機密情報・暗号化  | Secrets Manager / KMS                                       |
| 監視・ログ     | CloudWatch / CloudWatch Logs / CloudWatch Alarms            |
| 監査・構成管理   | CloudTrail / AWS Config                                     |
| 通知        | SNS / SES                                                   |
| コンテナレジストリ | ECR                                                         |
| CI/CD     | GitHub Actions                                              |
| IaC       | Terraform                                                   |
| コスト管理     | AWS Budgets                                                 |

---

## 3. コスト概算

> **注意:** 以下は設計時点の概算値。実際の料金はリージョン、通信量、リクエスト数、稼働時間等によって変動する。

### 3.1 本番想定構成

**前提：常時稼働**

> **TODO:** AWS Pricing Calculatorによる本番想定コストを記載

| サービス         |  月額概算 |
| ------------ | ----: |
| Aurora MySQL |     - |
| ECS Fargate  |     - |
| ALB          |     - |
| VPC Endpoint |     - |
| AWS WAF      |     - |
| その他          |     - |
| **合計**       | **-** |

### 3.2 検証用構成

**前提：1日平均2時間程度の利用**

| サービス                 |           月額概算 | 算出条件                                                                   |
| -------------------- | -------------: | ---------------------------------------------------------------------- |
| Aurora Serverless v2 |          $3.70 | Aurora MySQL / Standard / On-Demand / 1 ACU / Storage 1GB / Backup 0GB |
| VPC Endpoint         |          $6.40 | Interface Endpoint × 4 / 2 ENI / 月730時間を基準に利用時間を按分                     |
| AWS WAF              |          $6.60 | Web ACL × 1 / Rule × 1 / Rule Groupなし                                  |
| ECS Fargate          |          $1.88 | Linux x86 / 2タスク / 日 / 1タスク120分 / Ephemeral Storage 20GB               |
| ALB                  |          $1.48 | ALB × 1 / 1日平均約2時間 / 不使用時は削除                                           |
| **合計**               | **$20.06 / 月** |                                                                        |

※ 検証環境では、課金額を抑えるため、常時稼働が不要なリソースは検証時のみ起動・作成する。

---

## 4. 初期構築手順

### 4.1 前提

以下を事前に準備する。

* Terraform
* AWS CLI
* AWSアカウントへのアクセス権限
* AWS CLIプロファイル

また、対象環境について以下を設定する。

```text
environments/<env>/bootstrap/terraform.tfvars
environments/<env>/terraform.tfvars
environments/<env>/backend.tf
```

以降のコマンドはリポジトリのルートディレクトリから実行する。

### 4.2 AWS認証

環境名とAWS CLIプロファイルを設定する。

```bash
# STG / PRODの場合は環境名とプロファイルを変更
export TF_ENV=dev
export AWS_PROFILE=dev-account

aws login --profile "$AWS_PROFILE"
aws sts get-caller-identity
```

`aws sts get-caller-identity` の結果から、対象AWSアカウントで認証されていることを確認する。

### 4.3 Bootstrap構築

Terraform State保存用のS3バケットを作成する。

```bash
terraform -chdir="environments/$TF_ENV/bootstrap" init
terraform -chdir="environments/$TF_ENV/bootstrap" plan
terraform -chdir="environments/$TF_ENV/bootstrap" apply
```

作成されたState用S3バケット名を確認する。

```bash
terraform -chdir="environments/$TF_ENV/bootstrap" output -raw bucket_name
```

出力されたバケット名と、対象環境の `backend.tf` に設定している `bucket` が一致していることを確認する。

### 4.4 AWS環境構築

Terraformを初期化する。

```bash
terraform -chdir="environments/$TF_ENV" init
```

変更内容を確認する。

```bash
terraform -chdir="environments/$TF_ENV" plan
```

問題がなければAWS環境へ反映する。

```bash
terraform -chdir="environments/$TF_ENV" apply
```

`apply` 実行時は変更内容を確認したうえで `yes` を入力する。

以降の構成変更についても、原則として以下の流れで実施する。

```text
コード変更
    ↓
terraform plan
    ↓
変更内容確認
    ↓
terraform apply
```

### 4.5 State管理上の注意

Bootstrapで作成されるローカルStateは適切に保管すること。

既存Stateが存在する環境でBackendを変更する場合は、別途Stateの移行作業が必要となる。

> **注意:** 上記の構築コマンドのみでは、既存のルートStateは自動的に移行されない。
