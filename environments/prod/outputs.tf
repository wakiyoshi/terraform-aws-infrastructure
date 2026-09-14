output "route53_zone_id" {
  description = "ID of the prod public Route 53 hosted zone"
  value       = module.main.route53_zone_id
}

output "route53_name_servers" {
  description = "Add these name servers as an NS record in the waki-cloud-lab.com parent zone"
  value       = module.main.route53_name_servers
}

output "acm_certificate_arn" {
  description = "ARN of the validated ACM certificate for prod and its wildcard subdomains"
  value       = module.main.acm_certificate_arn
}
