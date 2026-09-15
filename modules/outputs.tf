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
