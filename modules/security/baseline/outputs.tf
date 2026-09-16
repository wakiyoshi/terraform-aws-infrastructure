output "config_recorder_name" {
  description = "AWS Config configuration recorder name"
  value       = aws_config_configuration_recorder.main.name
}

output "config_bucket_name" {
  description = "S3 bucket containing AWS Config history and snapshots"
  value       = aws_s3_bucket.config.id
}
