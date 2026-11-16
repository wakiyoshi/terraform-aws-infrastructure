data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  buckets = {
    frontend = {
      purpose       = "Frontend SPA assets"
      force_destroy = false
    }
  }
}

resource "aws_s3_bucket" "this" {
  for_each = local.buckets
  bucket = lower(
    "${var.project_name}-${var.environment}-${each.key}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}"
  )
  force_destroy = each.value.force_destroy

  tags = merge(var.common_tags, {
    Purpose = each.value.purpose
  })
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = local.buckets
  bucket   = aws_s3_bucket.this[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  for_each = local.buckets
  bucket   = aws_s3_bucket.this[each.key].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = local.buckets
  bucket   = aws_s3_bucket.this[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = local.buckets
  bucket   = aws_s3_bucket.this[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
