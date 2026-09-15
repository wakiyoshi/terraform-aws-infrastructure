output "cluster_id" {
  description = "Aurora cluster ID"
  value       = aws_rds_cluster.main.id
}

output "cluster_arn" {
  description = "Aurora cluster ARN"
  value       = aws_rds_cluster.main.arn
}

output "endpoint" {
  description = "Writer endpoint"
  value       = aws_rds_cluster.main.endpoint
}

output "reader_endpoint" {
  description = "Read-only endpoint"
  value       = aws_rds_cluster.main.reader_endpoint
}

output "port" {
  description = "Database port"
  value       = aws_rds_cluster.main.port
}

output "master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the master credentials"
  value       = try(aws_rds_cluster.main.master_user_secret[0].secret_arn, null)
}

output "serverless_min_capacity" {
  description = "Minimum Aurora Serverless v2 capacity in ACUs"
  value       = aws_rds_cluster.main.serverlessv2_scaling_configuration[0].min_capacity
}

output "serverless_max_capacity" {
  description = "Maximum Aurora Serverless v2 capacity in ACUs"
  value       = aws_rds_cluster.main.serverlessv2_scaling_configuration[0].max_capacity
}
