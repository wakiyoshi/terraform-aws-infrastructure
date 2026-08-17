output "zone_id" {
  description = "ID of the public Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Name servers assigned to the public Route 53 hosted zone"
  value       = aws_route53_zone.main.name_servers
}
