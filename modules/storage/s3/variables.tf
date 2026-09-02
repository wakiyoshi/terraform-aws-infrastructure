variable "project_name" {
  description = "Project name used for resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "bucket_name" {
  description = "Optional globally unique bucket name"
  type        = string
  default     = null
  nullable    = true
}

variable "force_destroy" {
  description = "Whether the bucket may be destroyed while it contains objects"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
