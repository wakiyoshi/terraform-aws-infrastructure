variable "project_name" {
  description = "Project name used for resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "bucket_name" {
  description = "Optional bucket name; a globally unique name is generated when omitted"
  type        = string
  default     = null
  nullable    = true
}

variable "log_prefix" {
  description = "S3 prefix under which ALB access logs are delivered"
  type        = string
  default     = "alb"

  validation {
    condition = (
      var.log_prefix != "" &&
      !strcontains(var.log_prefix, "AWSLogs") &&
      !startswith(var.log_prefix, "/") &&
      !endswith(var.log_prefix, "/")
    )
    error_message = "log_prefix must be non-empty, must not contain AWSLogs, and must not start or end with '/'."
  }
}

variable "retention_days" {
  description = "Number of days to retain ALB access logs"
  type        = number
  default     = 90

  validation {
    condition     = var.retention_days >= 1
    error_message = "retention_days must be at least 1."
  }
}

variable "force_destroy" {
  description = "Whether the bucket can be destroyed while it contains logs"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
