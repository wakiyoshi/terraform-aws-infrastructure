output "route53_zone_id" {
  description = "ID of the prod public Route 53 hosted zone"
  value       = try(module.route53[0].zone_id, null)
}

output "route53_name_servers" {
  description = "Name servers used to delegate the prod subdomain from its parent zone"
  value       = try(module.route53[0].name_servers, [])
}

output "acm_certificate_arn" {
  description = "ARN of the DNS-validated regional ACM certificate for prod"
  value       = try(module.acm[0].certificate_arn, null)
}

output "cloudfront_distribution_id" {
  description = "ID of the environment's CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.domain_name
}

output "site_url" {
  description = "Public site URL served by CloudFront"
  value       = var.environment == "prod" ? "https://${var.domain_name}" : "https://${module.cloudfront.domain_name}"
}

output "ses_identity_arn" {
  description = "ARN of the prod SES domain identity"
  value       = try(module.ses[0].identity_arn, null)
}

output "ses_domain_name" {
  description = "Authenticated prod SES sending domain"
  value       = try(module.ses[0].domain_name, null)
}

output "ses_mail_from_domain" {
  description = "Custom prod SES MAIL FROM domain"
  value       = try(module.ses[0].mail_from_domain, null)
}

output "ses_configuration_set_name" {
  description = "Default prod SES configuration set name"
  value       = try(module.ses[0].configuration_set_name, null)
}

output "rds_cluster_id" {
  description = "Aurora cluster ID; null when paid resources are disabled"
  value       = try(module.rds[0].cluster_id, null)
}

output "rds_endpoint" {
  description = "Aurora writer endpoint; null when paid resources are disabled"
  value       = try(module.rds[0].endpoint, null)
}

output "rds_reader_endpoint" {
  description = "Aurora reader endpoint; null when paid resources are disabled"
  value       = try(module.rds[0].reader_endpoint, null)
}

output "rds_port" {
  description = "Aurora port; null when paid resources are disabled"
  value       = try(module.rds[0].port, null)
}

output "rds_master_user_secret_arn" {
  description = "ARN of the managed master credential secret; null when paid resources are disabled"
  value       = try(module.rds[0].master_user_secret_arn, null)
  sensitive   = true
}

output "rds_secrets_kms_key_arn" {
  description = "ARN of the KMS key used by the RDS-managed secret"
  value       = module.rds_secrets_kms.key_arn
}
