# CloudFrontの配信対象には含めず、アプリケーションからのみ利用する。
resource "aws_s3_bucket_policy" "attachments" {
  bucket = aws_s3_bucket.this["attachments"].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "DenyInsecureTransport"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource = [
        aws_s3_bucket.this["attachments"].arn,
        "${aws_s3_bucket.this["attachments"].arn}/*",
      ]
      Condition = { Bool = { "aws:SecureTransport" = "false" } }
    }]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "attachments" {
  bucket = aws_s3_bucket.this["attachments"].id

  depends_on = [aws_s3_bucket_versioning.this]

  rule {
    id     = "cleanup-old-versions-and-incomplete-uploads"
    status = "Enabled"
    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
