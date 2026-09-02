variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "container_name" {
  type    = string
  default = "app"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}