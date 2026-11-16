# DEV一時構成: VPC・S3・ECRのみ。通常構成とリソースアドレスを揃える。
module "vpc" {
  source                = "../../../modules/vpc"
  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  application_port      = var.application_port
  common_tags           = var.common_tags
  enable_paid_resources = var.enable_paid_resources
}

module "s3" {
  source       = "../../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

module "ecr" {
  source = "../../../modules/ecr"

  project_name                   = var.project_name
  environment                    = var.environment
  common_tags                    = var.common_tags
  keep_image_count               = var.keep_image_count
  untagged_image_expiration_days = var.untagged_image_expiration_days
}

moved {
  from = module.ecr[0]
  to   = module.ecr
}

output "ecr_repository_name" {
  value = module.ecr.repository_name
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "application_port" {
  type = number
}

variable "enable_paid_resources" {
  type    = bool
  default = false
}

variable "keep_image_count" {
  type    = number
  default = 10
}

variable "untagged_image_expiration_days" {
  type    = number
  default = 7
}
