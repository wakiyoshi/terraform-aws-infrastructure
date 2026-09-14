variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "frontend_bucket_name" {
  type    = string
  default = null
}

variable "frontend_bucket_force_destroy" {
  type    = bool
  default = false
}

variable "common_tags" {
  type = map(string)
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "application_port" {
  type = number
}

variable "domain_name" {
  type = string
}

variable "enable_paid_resources" {
  type    = bool
  default = false
}

variable "keep_image_count" {
  type    = number
  default = 10
}

variable "untagged_image_expiration_days" {
  type    = number
  default = 7
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "container_name" {
  type    = string
  default = "app"
}

variable "task_cpu" {
  type    = number
  default = 512
}

variable "task_memory" {
  type    = number
  default = 1024
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "autoscaling_min_capacity" {
  type    = number
  default = 2
}

variable "autoscaling_max_capacity" {
  type    = number
  default = 4
}

variable "autoscaling_cpu_target" {
  type    = number
  default = 60
}

variable "log_retention_days" {
  type    = number
  default = 30
}

variable "container_environment" {
  type    = map(string)
  default = {}
}
