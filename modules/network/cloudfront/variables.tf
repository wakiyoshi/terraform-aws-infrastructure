variable "project_name" {
  description = "Project name used for resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "frontend_bucket_id" {
  description = "Name of the frontend S3 bucket"
  type        = string
}

variable "frontend_bucket_arn" {
  description = "ARN of the frontend S3 bucket"
  type        = string
}

variable "frontend_bucket_regional_domain_name" {
  description = "Regional domain name of the frontend S3 bucket"
  type        = string
}

variable "alb_origin_domain_name" {
  description = "HTTPS domain name that resolves to the ALB and matches its certificate"
  type        = string
}

variable "backend_path_pattern" {
  description = "Path pattern routed to the ALB"
  type        = string
  default     = "/api/*"
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_200"
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
