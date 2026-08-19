output "route53_name_servers" {
  description = "Name servers assigned to the public Route 53 hosted zone"
  value       = module.route53.name_servers
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain used to access the SPA and API"
  value       = module.cloudfront.domain_name
}

output "frontend_bucket_name" {
  description = "Name of the private S3 bucket for frontend files"
  value       = module.s3.bucket_id
}
