variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "application_port" {
  type = number
}

variable "domain_name" {
  description = "Domain name used by the ACM certificate and Route 53 ALB record"
  type        = string

  validation {
    condition     = length(trimspace(var.domain_name)) > 0
    error_message = "domain_name must not be empty."
  }
}

variable "frontend_bucket_name" {
  description = "Optional globally unique name for the frontend asset bucket"
  type        = string
  default     = null
  nullable    = true
}

variable "frontend_bucket_force_destroy" {
  description = "Whether the frontend bucket may be destroyed while it contains objects"
  type        = bool
  default     = false
}

variable "backend_path_pattern" {
  description = "CloudFront path pattern routed to the ALB origin"
  type        = string
  default     = "/api/*"

  validation {
    condition     = startswith(var.backend_path_pattern, "/") && strcontains(var.backend_path_pattern, "*")
    error_message = "backend_path_pattern must start with '/' and contain '*'."
  }
}

variable "cloudfront_price_class" {
  description = "CloudFront edge location price class"
  type        = string
  default     = "PriceClass_200"

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_price_class)
    error_message = "cloudfront_price_class must be PriceClass_100, PriceClass_200, or PriceClass_All."
  }
}
