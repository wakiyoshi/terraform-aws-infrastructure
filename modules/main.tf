//vpc
module "vpc" {
  source             = "./network/vpc"
  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  application_port   = var.application_port
  common_tags        = var.common_tags
  enable_paid_resources = var.enable_paid_resources
}

//storage
module "s3" {
  source        = "./storage/s3"
  project_name  = var.project_name
  environment   = var.environment
  common_tags   = var.common_tags
}
