data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  generated_bucket_name = lower(
    "${var.project_name}-${var.environment}-frontend-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}"
  )
  bucket_name = coalesce(var.bucket_name, local.generated_bucket_name)
}

resource "aws_s3_bucket" "frontend" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = merge(var.common_tags, {
    Name    = local.bucket_name
    Purpose = "Frontend SPA assets"
  })
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
