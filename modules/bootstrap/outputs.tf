output "terraform_deploy_role_arn" {
  description = "ARN of the GitHub Actions role used by the Terraform repository"
  value       = aws_iam_role.terraform_deploy.arn
}

output "application_deploy_role_arn" {
  description = "ARN of the GitHub Actions role used by the application repository"
  value       = aws_iam_role.application_deploy.arn
}

output "github_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}
