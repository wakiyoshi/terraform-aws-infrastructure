output "repository_url" {
  description = "URL of the environment ECR repository"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_name" {
  description = "Name of the environment ECR repository"
  value       = aws_ecr_repository.main.name
}
