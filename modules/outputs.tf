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
