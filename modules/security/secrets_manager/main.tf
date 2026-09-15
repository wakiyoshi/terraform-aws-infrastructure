data "aws_iam_policy_document" "rds_master_user" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["secretsmanager:*"]
    resources = [var.secret_arn]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_secretsmanager_secret_policy" "rds_master_user" {
  secret_arn          = var.secret_arn
  policy              = data.aws_iam_policy_document.rds_master_user.json
  block_public_policy = true
}
