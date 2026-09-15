variable "project_name" {
  description = "Project name used for resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the DB subnet group"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required for Aurora."
  }
}

variable "rds_security_group_id" {
  description = "Security group ID attached to the Aurora cluster"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}

variable "database_name" {
  description = "Name of the initial database"
  type        = string
  default     = "app"
}

variable "master_username" {
  description = "Master database username; its password is managed by Secrets Manager"
  type        = string
  default     = "dbadmin"
}

variable "master_user_secret_kms_key_id" {
  description = "KMS key ARN used to encrypt the RDS-managed master-user secret"
  type        = string
}

variable "engine_version" {
  description = "Aurora MySQL engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.08.2"
}

variable "instance_count" {
  description = "Number of Aurora instances"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be at least 1."
  }
}

variable "serverless_min_capacity" {
  description = "Minimum Aurora Serverless v2 capacity in ACUs"
  type        = number

  validation {
    condition = (
      var.serverless_min_capacity >= 0.5 &&
      var.serverless_min_capacity <= 256 &&
      var.serverless_min_capacity * 2 == floor(var.serverless_min_capacity * 2)
    )
    error_message = "serverless_min_capacity must be between 0.5 and 256 ACUs in 0.5-ACU increments."
  }
}

variable "serverless_max_capacity" {
  description = "Maximum Aurora Serverless v2 capacity in ACUs"
  type        = number

  validation {
    condition = (
      var.serverless_max_capacity >= var.serverless_min_capacity &&
      var.serverless_max_capacity <= 256 &&
      var.serverless_max_capacity * 2 == floor(var.serverless_max_capacity * 2)
    )
    error_message = "serverless_max_capacity must be at least the minimum, no more than 256 ACUs, and use 0.5-ACU increments."
  }
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Daily UTC backup window"
  type        = string
  default     = "18:00-19:00"
}

variable "preferred_maintenance_window" {
  description = "Weekly UTC maintenance window"
  type        = string
  default     = "sun:19:00-sun:20:00"
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the cluster"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Whether database changes are applied immediately"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Whether Performance Insights is enabled"
  type        = bool
  default     = true
}

variable "iam_database_authentication_enabled" {
  description = "Whether IAM database authentication is enabled"
  type        = bool
  default     = true
}
