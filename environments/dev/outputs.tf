output "route53_zone_id" {
  description = "ID of the environment public Route 53 hosted zone"
  value       = module.main.route53_zone_id
}

output "route53_name_servers" {
  description = "Name servers to register in the PROD parent zone"
  value       = module.main.route53_name_servers
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.main.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.main.cloudfront_domain_name
}

output "site_url" {
  description = "Public site URL served by CloudFront"
  value       = module.main.site_url
}

output "ecr_repository_name" {
  description = "Name of the DEV ECR repository"
  value       = module.main.ecr_repository_name
}


output "rds_cluster_id" {
  description = "Aurora cluster ID"
  value       = module.main.rds_cluster_id
}

output "rds_endpoint" {
  description = "Aurora writer endpoint"
  value       = module.main.rds_endpoint
}

output "rds_reader_endpoint" {
  description = "Aurora reader endpoint"
  value       = module.main.rds_reader_endpoint
}

output "rds_port" {
  description = "Aurora port"
  value       = module.main.rds_port
}

output "rds_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the Aurora master credentials"
  value       = module.main.rds_master_user_secret_arn
  sensitive   = true
}

output "rds_secrets_kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the RDS master-user secret"
  value       = module.main.rds_secrets_kms_key_arn
}

output "cloudwatch_alarm_arns" {
  value = module.main.cloudwatch_alarm_arns
}

output "config_recorder_name" {
  value = module.main.config_recorder_name
}

output "config_bucket_name" {
  value = module.main.config_bucket_name
}

output "cloudtrail_arn" {
  value = module.main.cloudtrail_arn
}

output "cloudtrail_bucket_name" {
  value = module.main.cloudtrail_bucket_name
}

output "guardduty_detector_id" {
  value = module.main.guardduty_detector_id
}

output "securityhub_arn" {
  value = module.main.securityhub_arn
}

output "ecr_scan_type" {
  value = module.main.ecr_scan_type
}

output "attachments_bucket_name" {
  description = "Private bucket for application attachments"
  value       = module.main.attachments_bucket_name
}
