output "route53_name_servers" {
  description = "Name servers assigned to the public Route 53 hosted zone"
  value       = module.route53.name_servers
}
