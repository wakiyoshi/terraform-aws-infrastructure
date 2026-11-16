output "validation_record_fqdns" {
  description = "DNS validation records owned by this module"
  value       = [for record in aws_route53_record.validation : record.fqdn]
}

output "certificate_arn" {
  description = "ARN of the validated ACM certificate"
  value       = aws_acm_certificate_validation.main.certificate_arn
}
