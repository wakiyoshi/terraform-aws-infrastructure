//「誰に・どのAWSアカウントで・どのPermission Setを付与するか」


# グループ名から既存グループを取得
data "aws_identitystore_group" "this" {
  for_each = var.account_assignments

  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value.group_name
    }
  }
}

# グループにPermission Setを割り当て
resource "aws_ssoadmin_account_assignment" "this" {
  for_each = var.account_assignments

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this.arn

  principal_id   = data.aws_identitystore_group.this[each.key].group_id
  principal_type = "GROUP"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"

  depends_on = [
    aws_ssoadmin_managed_policy_attachment.this
  ]
}