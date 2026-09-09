//手動で有効化したadmin instaceのデータを取得
data "aws_ssoadmin_instances" "this" {}

//共通の変数を定義
locals {
  //oneでaws_ssoadmin_instancesのリストから1つだけ値を取得
  instance_arn = one(data.aws_ssoadmin_instances.this.arns)
  identity_store_id = one(
    data.aws_ssoadmin_instances.this.identity_store_ids
  )
}

//resource 管理対象
resource "aws_ssoadmin_permission_set" "this" {
  name             = var.permission_set_name
  description      = "Managed by Terraform"
  instance_arn     = local.instance_arn
  session_duration = "PT4H"
}

resource "aws_ssoadmin_managed_policy_attachment" "readonly" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"

  depends_on = [
    aws_ssoadmin_account_assignment.this
  ]
}