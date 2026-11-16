output "trail_arn" {
  description = "ARN of the multi-Region management event trail"
  value       = aws_cloudtrail.main.arn
}

output "bucket_name" {
  description = "S3 bucket containing CloudTrail logs and validation digests"
  value       = aws_s3_bucket.logs.id
}
