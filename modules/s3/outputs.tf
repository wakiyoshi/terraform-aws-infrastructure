output "bucket_id" {
  description = "Name of the ALB access log bucket"
  value       = aws_s3_bucket.alb_access_logs.id
}

output "bucket_arn" {
  description = "ARN of the ALB access log bucket"
  value       = aws_s3_bucket.alb_access_logs.arn
}

output "log_prefix" {
  description = "Prefix used for ALB access logs"
  value       = var.log_prefix
}

output "log_s3_uri" {
  description = "S3 URI used for ALB access logs"
  value       = "s3://${aws_s3_bucket.alb_access_logs.id}/${var.log_prefix}"
}
