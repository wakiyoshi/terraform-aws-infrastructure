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
  description = "Domain name of the ALB origin; null when the ALB is disabled"
  type        = string
  default     = null
  nullable    = true
}

variable "enable_alb_origin" {
  description = "Whether the ALB origin and backend cache behavior are enabled"
  type        = bool
  default     = false
}

variable "alb_origin_protocol_policy" {
  description = "Protocol policy used between CloudFront and the ALB"
  type        = string
  default     = "https-only"

  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.alb_origin_protocol_policy)
    error_message = "alb_origin_protocol_policy must be http-only, https-only, or match-viewer."
  }
}

variable "aliases" {
  description = "Alternate domain names served by the distribution"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of the us-east-1 ACM certificate used by CloudFront"
  type        = string
  default     = null
  nullable    = true
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

variable "waf_log_retention_days" {
  description = "CloudWatch Logs retention period for WAF logs"
  type        = number
  default     = 30
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}

variable "cloudfront_basic_auth" {
  description = "Optional Basic auth credentials; supply outside committed tfvars"
  type = object({
    username = string
    password = string
  })
  default   = null
  sensitive = true

  validation {
    condition = var.cloudfront_basic_auth == null ? true : (
      length(var.cloudfront_basic_auth.username) > 0 &&
      !strcontains(var.cloudfront_basic_auth.username, ":") &&
      length(var.cloudfront_basic_auth.password) > 0
    )
    error_message = "Use a nonempty username without colon, a nonempty password."
  }
}

variable "enable_paid_resources" {
  description = "Whether to create the WAF web ACL, its rules, and logging resources"
  type        = bool
  default     = false
}
