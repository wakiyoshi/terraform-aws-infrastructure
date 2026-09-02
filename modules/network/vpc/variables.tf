variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "application_port" {
  description = "Application port"
  type        = number
}
