variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

// HTTPS（TLS）通信を成立させるために証明書が必須
variable "certificate_arn" {
  description = "ARN of the ACM certificate used by the HTTPS listener"
  type        = string
}

variable "ssl_policy" {
  description = "TLS security policy used by the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
}

variable "application_port" {
  description = "Application port"
  type        = number
}

variable "health_check_path" {
  default = "/health"
}