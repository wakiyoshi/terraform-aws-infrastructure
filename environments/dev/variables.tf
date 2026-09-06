variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "application_port" { type = number }
variable "domain_name" { type = string }
variable "frontend_bucket_name" {
  type    = string
  default = null
}
variable "frontend_bucket_force_destroy" {
  type    = bool
  default = false
}
variable "enable_paid_resources" {
  type    = bool
  default = false
}
