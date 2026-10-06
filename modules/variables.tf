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

variable "cloudfront_backend_path_pattern" {
  description = "CloudFront path pattern routed to the ALB"
  type        = string
  default     = "/api/*"
}

variable "cloudfront_price_class" {
  description = "CloudFront edge-location price class"
  type        = string
  default     = "PriceClass_200"
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

variable "database_name" {
  description = "Name of the initial Aurora database"
  type        = string
  default     = "app"
}

variable "kms_deletion_window_in_days" {
  description = "Waiting period before a scheduled deletion of the RDS secrets KMS key"
  type        = number
  default     = 30
}

variable "database_master_username" {
  description = "Aurora master username; the password is managed by Secrets Manager"
  type        = string
  default     = "dbadmin"
}

variable "aurora_engine_version" {
  description = "Aurora MySQL engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.08.2"
}

variable "rds_instance_count" {
  description = "Number of Aurora Serverless v2 instances"
  type        = number
  default     = 1
}

variable "aurora_serverless_min_capacity" {
  description = "Minimum Aurora Serverless v2 capacity in ACUs"
  type        = number
}

variable "aurora_serverless_max_capacity" {
  description = "Maximum Aurora Serverless v2 capacity in ACUs"
  type        = number
}

variable "rds_backup_retention_period" {
  description = "Number of days to retain Aurora automated backups"
  type        = number
  default     = 7
}

variable "rds_preferred_backup_window" {
  description = "Daily UTC backup window"
  type        = string
  default     = "18:00-19:00"
}

variable "rds_preferred_maintenance_window" {
  description = "Weekly UTC maintenance window"
  type        = string
  default     = "sun:19:00-sun:20:00"
}

variable "rds_deletion_protection" {
  description = "Whether Aurora deletion protection is enabled"
  type        = bool
  default     = true
}

variable "rds_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting Aurora"
  type        = bool
  default     = false
}

variable "rds_apply_immediately" {
  description = "Whether Aurora changes are applied immediately"
  type        = bool
  default     = false
}

variable "rds_performance_insights_enabled" {
  description = "Whether Performance Insights is enabled"
  type        = bool
  default     = true
}

variable "rds_iam_database_authentication_enabled" {
  description = "Whether IAM database authentication is enabled"
  type        = bool
  default     = true
}

variable "cloudwatch_alarm_actions" {
  description = "Additional SNS topic ARNs in the same Region for CloudWatch alarm and recovery notifications"
  type        = list(string)
  default     = []
}

variable "config_include_global_resource_types" {
  description = "Record legacy global IAM resources; enable in only one supported Region per account"
  type        = bool
  default     = true
}

variable "cloudwatch_alarm_email_addresses" {
  description = "Email recipients for CloudWatch alarm and recovery notifications; each subscription requires email confirmation"
  type        = set(string)
  default     = []
}
