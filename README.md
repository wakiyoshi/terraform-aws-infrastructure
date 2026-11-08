# 医療法人補助金申請システム(架空の案件)

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
* 障害発生時、セキュリティインシデント発生時の迅速な原因調査および復旧

---

## 2. サービスの前提条件

### 2.1 利用規模・利用特性

| 項目 | 前提条件 |
| --- | --- |
| 対象地域 | 日本全国（国内のみ） |
| 対象事業者 | 病院、診療所等の医療事業者 |
| 登録事業者数 | 約120,000事業者 |
| 登録ユーザー数 | 約300,000ユーザー |
| 通常時デイリーアクティブユーザー（DAU） | 約30,000人 |
| 繁忙期デイリーアクティブユーザー（DAU） | 約100,000人 |
| 通常時同時接続数 | 約1,000人 |
| ピーク時同時接続数 | 約10,000人 |
| 通常時リクエスト数（RPS） | 50～100 RPS |
| ピーク時リクエスト数（RPS） | 500～1,000 RPS |
| 主な利用時間 | 平日 8:00～20:00 |
| サービス提供時間 | 原則として24時間365日 |
| アクセス集中時期 | 3月、6月、9月および12月の四半期末 |
| 繁忙期アクセス量 | 通常時の5～10倍程度を想定 |

### 2.2 可用性

| 項目 | 前提条件 |
| --- | --- |
| 目標稼働率 | 99.9%以上とする。 |
| アベイラビリティゾーン障害 | 単一のアベイラビリティゾーンに障害が発生した場合も、サービスを継続できる構成とする。 |
| 目標復旧時間（RTO） | 目標1時間以内とする。 |
| 目標復旧時点（RPO） | 5分以内とする。 |
| バックアップ | データベースおよび重要データを定期的にバックアップする。 |

---

## 3. システム構成

### 3.1 システム構成図
<img width="2352" height="1466" alt="aws_architecture_all_inside_cloud drawio20261027" src="https://github.com/user-attachments/assets/140e60d4-9485-44f9-9159-8a9cfda7550f" />


### 3.2 主な構成

| 分類        | AWSサービス・技術                                                  |
| --------- | ----------------------------------------------------------- |
| コンピューティング | ECS Fargate / Service Auto Scaling                          |
| ネットワーク    | VPC / Subnet / Security Group / Route 53 / CloudFront / ALB |
| 証明書       | ACM                                                         |
| データベース    | Aurora MySQL （Serverless v2）                                             |
| ストレージ     | S3                                                          |
| 管理者・運用者認証        | IAM Identity Center                                         |
| セキュリティ    | AWS WAF / GuardDuty / Security Hub / Inspector              |
| 組織管理      | AWS Organizations                                           |
| 機密情報・暗号化  | Secrets Manager / KMS                                       |
| 監視・ログ     | CloudWatch / CloudWatch Logs / CloudWatch Alarms            |
| 監査・構成管理   | CloudTrail / AWS Config                                     |
| 通知        | SNS / SES                                                   |
| コンテナレジストリ | ECR                                                         |
| CI/CD     | GitHub Actions                                              |
| IaC       | Terraform                                                   |
| コスト管理     | AWS Budgets CostExplorer                                              |

---

## 4. コスト概算

> **注意:** 以下は設計時点の概算値。実際の料金はリージョン、通信量、リクエスト数、稼働時間等によって変動する。

### 4.1 本番想定構成(1環境)

**前提：常時稼働**

| サービス                 |                  月額概算 | 算出条件                                                                         |
| -------------------- | --------------------: | ---------------------------------------------------------------------------- |
| Aurora Serverless v2 | $382.61（約57,400円） | Aurora MySQL / Standard / On-Demand / 平均4 ACU / Storage 20GB / Backup 20GB |
| ECS Fargate          | $179.94（約27,000円） | Linux x86 / 平均4タスク / 1 vCPU・2GB / 24時間稼働 / Ephemeral Storage 20GB           |
| ALB                  |  $20.66（約3,100円） | ALB × 1 / 24時間稼働 / LCU利用量を考慮                                                 |
| Regional NAT Gateway | $91.76（約13,800円） | Regional NAT Gateway × 1 / 2AZ / 24時間稼働                                      |
| **合計**               | **$674.97（約101,200円）** | **主要ワークロードサービスのみの本番想定概算（繁忙期考慮で多めに見積もっている）**                                                 |


※ 1 USD = 150円で換算。年間では 約$8,099.64（約121.5万円）。
※ CloudFront、WAF、S3、CloudWatch、Route 53、ECR、SES等は含まない。

## 5. 初期構築手順

以下はDEVの例。STG / PRODでは環境名・プロファイルを変更する。コマンドはリポジトリのルートで実行する。

### 5.1 BootstrapでState保存先を作成

1. `environments/dev/bootstrap/terraform.tfvars` を設定する。
2. AWSへログインし、State用S3バケットとCI/CD用Roleを作成する。

   ```bash
   export AWS_PROFILE=dev-account
   aws sso login --profile "$AWS_PROFILE"
   aws sts get-caller-identity

   terraform -chdir=environments/dev/bootstrap init
   terraform -chdir=environments/dev/bootstrap plan
   terraform -chdir=environments/dev/bootstrap apply

   terraform -chdir=environments/dev/bootstrap output
   ```

### 5.2 CI/CDを設定

1. 出力された `bucket_name` を `environments/dev/backend.tf` の `bucket` に設定する。
2. GitHubのRepository Variablesを設定する（STG / PRODも同様）。

   | Variable | 設定値 |
   | --- | --- |
   | `AWS_ACCOUNT_ID_DEV` | DEVのAWSアカウントID |
   | `AWS_ROLE_ARN_DEV` | Bootstrapの `terraform_deploy_role_arn` |

3. GitHub Environmentに `DEV` / `STG` / `PROD` を作成し、全環境にRequired reviewersを設定し、デプロイ可能なブランチをmainに限定する。

### 5.3 CI/CDでapply

1. `environments/dev/terraform.tfvars` の `enable_paid_resources=false` でPRを作成し、自動のfmt・validate成功後にmainへマージする。
2. Actions → **Terraform CI / Apply** → **Run workflow** で、ブランチ `main`・環境 `DEV` を選択して実行する（ECRを作成）。
3. Application側でECRへのイメージpushを完了する。
4. `enable_paid_resources=true` に変更し、PRチェック成功・マージ後、同じWorkflowを再実行する。
5. Job Summaryのplanを確認し、GitHub Environmentで承認して保存済みplanをapplyする。Planの保存期間は1日。期限切れや再実行時はWorkflow全体を再実行し、新しいPlanを確認・承認する。

※ PRではAWS認証せず、各環境を `init -backend=false` してvalidateする。BootstrapのローカルStateは保管する。

### 5.4 運用ルール

* ローカルCLIからの `terraform plan`・`terraform apply` などによる環境への直接操作は原則禁止とする。
* 通常の変更はPRを作成し、マージ後にGitHub Actionsから対象環境へplan,applyする。
* ただし初期構築時のBootstrapは例外とする。障害対応などでCLI操作が必要な場合は、事前承認を得て実施し、操作内容と結果を記録する。
