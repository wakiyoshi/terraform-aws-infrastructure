variable "project_name" { type = string }
variable "environment" { type = string }
variable "common_tags" {
  type    = map(string)
  default = {}
}
variable "include_global_resource_types" {
  description = "Record legacy global IAM resource types in this Region; enable in only one supported Region per account"
  type        = bool
  default     = false
}
