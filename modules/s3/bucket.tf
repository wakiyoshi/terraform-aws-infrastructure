data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  generated_bucket_name = lower(
    "${var.project_name}-${var.environment}-alb-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}"
  )
  // ユーザーが指定したものがある場合はそれを優先する
  bucket_name = coalesce(var.bucket_name, local.generated_bucket_name)
}

resource "aws_s3_bucket" "alb_access_logs" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.common_tags, {
    Name    = local.bucket_name
    Purpose = "ALB access logs"
  })
}

//　パブリックブロック設定
resource "aws_s3_bucket_public_access_block" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "alb_access_logs" {
  bucket = aws_s3_bucket.alb_access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
