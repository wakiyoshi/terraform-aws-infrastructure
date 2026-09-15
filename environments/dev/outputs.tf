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
