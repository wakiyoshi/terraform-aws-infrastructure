variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "application_port" { type = number }
variable "domain_name" { type = string }
variable "frontend_bucket_name" {
  type    = string
  default = null
}
variable "frontend_bucket_force_destroy" {
  type    = bool
  default = false
}
variable "enable_paid_resources" {
  type    = bool
  default = false
}

variable "keep_image_count" { type = number }
variable "untagged_image_expiration_days" { type = number }
variable "ssl_policy" { type = string }
variable "health_check_path" { type = string }
variable "bootstrap_image_tag" { type = string }
variable "container_name" { type = string }
variable "task_cpu" { type = number }
variable "task_memory" { type = number }
variable "desired_count" { type = number }
variable "autoscaling_min_capacity" { type = number }
variable "autoscaling_max_capacity" { type = number }
variable "autoscaling_cpu_target" { type = number }
variable "log_retention_days" { type = number }
variable "container_environment" { type = map(string) }
variable "database_name" { type = string }
variable "database_master_username" { type = string }
variable "aurora_engine_version" { type = string }
variable "rds_instance_count" { type = number }
variable "aurora_serverless_min_capacity" { type = number }
variable "aurora_serverless_max_capacity" { type = number }
variable "rds_backup_retention_period" { type = number }
variable "rds_deletion_protection" { type = bool }
variable "rds_skip_final_snapshot" { type = bool }

variable "cloudwatch_alarm_actions" {
  description = "SNS topic ARNs in the same Region for CloudWatch alarm and recovery notifications; empty disables notifications"
  type        = list(string)
  default     = []
}

variable "config_include_global_resource_types" {
  description = "Record legacy global IAM resources; enable in only one supported Region per account"
  type        = bool
  default     = true
}
