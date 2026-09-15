output "identity_arn" {
  description = "ARN of the verified SES domain identity"
  value       = aws_sesv2_email_identity.main.arn
}

output "domain_name" {
  description = "Authenticated SES sending domain"
  value       = aws_sesv2_email_identity.main.email_identity
}

output "mail_from_domain" {
  description = "Custom SES MAIL FROM domain"
  value       = local.mail_from_domain
}

output "configuration_set_name" {
  description = "Default SES configuration set name"
  value       = aws_sesv2_configuration_set.main.configuration_set_name
}
