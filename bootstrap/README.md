# Terraform backend bootstrap

Terraform State 保存用 S3 バケットだけを作成する、初回セットアップ用の構成です。
このディレクトリでは S3 backend を設定せず、bootstrap 自身の State はローカルに保持します。

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
terraform output -raw state_bucket_name
```

表示されたバケット名をルートの `backend.tf` に設定した後、ルートディレクトリで
`terraform init -reconfigure` を実行してください。

バケットには誤削除防止の `prevent_destroy` を設定しています。この bootstrap の
`apply` は初回だけ実行し、生成された `terraform.tfstate` は安全に保管してください。
