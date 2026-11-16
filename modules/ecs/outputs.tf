output "task_role_name" {
  description = "Name of the IAM role used by the application container"
  value       = aws_iam_role.task.name
}

output "task_role_arn" {
  description = "ARN of the IAM role used by the application container"
  value       = aws_iam_role.task.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  value = aws_ecs_service.main.name
}
