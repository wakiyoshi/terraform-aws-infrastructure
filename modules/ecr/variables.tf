variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}

variable "keep_image_count" {
  description = "Number of tagged container images to retain"
  type        = number
  default     = 10

  validation {
    condition     = var.keep_image_count > 0
    error_message = "keep_image_count must be greater than 0."
  }
}

variable "untagged_image_expiration_days" {
  description = "Days before untagged images are deleted"
  type        = number
  default     = 7

  validation {
    condition     = var.untagged_image_expiration_days > 0
    error_message = "untagged_image_expiration_days must be greater than 0."
  }
}
