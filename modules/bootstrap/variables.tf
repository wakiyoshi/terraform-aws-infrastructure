variable "project_name" {
  description = "Project name used to scope application deployment resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "environment must be one of dev, stg, or prod."
  }
}

variable "aws_region" {
  description = "AWS Region containing the environment resources"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID containing the environment resources"
  type        = string
}

variable "application_github_repository" {
  description = "GitHub repository allowed to assume the application deployment role"
  type        = string
}
