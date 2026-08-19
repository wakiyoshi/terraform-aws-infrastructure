variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "domain_name" {
  description = "Domain name used by the public hosted zone and ALB record"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}
