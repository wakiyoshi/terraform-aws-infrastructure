output "config_recorder_name" {
  description = "AWS Config configuration recorder name"
  value       = aws_config_configuration_recorder.main.name
}

output "config_bucket_name" {
  description = "S3 bucket containing AWS Config history and snapshots"
  value       = aws_s3_bucket.config.id
}

output "guardduty_detector_id" {
  description = "Regional GuardDuty detector ID"
  value       = aws_guardduty_detector.main.id
}

output "securityhub_arn" {
  description = "Regional Security Hub CSPM ARN"
  value       = aws_securityhub_account.main.arn
}

output "ecr_scan_type" {
  description = "Registry scanning type managed by Inspector"
  value       = aws_ecr_registry_scanning_configuration.main.scan_type
}
