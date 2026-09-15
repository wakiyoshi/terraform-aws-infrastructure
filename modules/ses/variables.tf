variable "project_name" {
  description = "Project name used for resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS Region where SES sends email"
  type        = string
}

variable "domain_name" {
  description = "Site domain authenticated as the SES sending identity"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID used for SES authentication records"
  type        = string
}

variable "dmarc_record" {
  description = "DMARC TXT record value"
  type        = string
  default     = "v=DMARC1; p=none; adkim=s; aspf=r; pct=100"
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
