variable "project_name" {
  description = "Project name used in the Terraform State bucket name"
  type        = string
  default     = "grant-application"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "aws_region" {
  description = "AWS Region in which to create the Terraform State bucket"
  type        = string
  default     = "ap-northeast-1"
}
