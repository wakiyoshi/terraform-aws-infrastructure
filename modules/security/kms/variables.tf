variable "project_name" {
  description = "Project name used for resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "alias_suffix" {
  description = "Suffix used for the KMS alias"
  type        = string
  default     = "secrets"
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
}

variable "deletion_window_in_days" {
  description = "Waiting period before a scheduled KMS key deletion"
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30 days."
  }
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
