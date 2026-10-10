# Store the existing Laravel key through the console after apply.
# Terraform manages only the secret metadata, never its value.
resource "aws_secretsmanager_secret" "app_key" {
  name                    = "${var.project_name}-dev-app-key"
  description             = "Laravel APP_KEY for dev; value managed outside Terraform"
  recovery_window_in_days = 30

  lifecycle {
    prevent_destroy = true
  }
}

output "app_key_secret_arn" {
  description = "Secret to populate with the existing Laravel APP_KEY as plain text"
  value       = aws_secretsmanager_secret.app_key.arn
}
