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
