variable "project_name" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "availability_zones" {
  type        = list(string)
}

variable "application_port" {
  type        = number
}

variable "domain_name" {
  description = "Domain name used by the ACM certificate and Route 53 ALB record"
  type        = string

  validation {
    condition     = length(trimspace(var.domain_name)) > 0
    error_message = "domain_name must not be empty."
  }
}
