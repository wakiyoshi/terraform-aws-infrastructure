//vpc
module "vpc" {
  source                = "./network/vpc"
  project_name          = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  application_port      = var.application_port
  common_tags           = var.common_tags
  enable_paid_resources = var.enable_paid_resources
}

//storage
module "s3" {
  source       = "./storage/s3"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

module "route53" {
  count  = var.environment == "prod" ? 1 : 0
  source = "./network/route53"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  common_tags  = var.common_tags
}

module "acm" {
  count  = var.environment == "prod" ? 1 : 0
  source = "./security/acm"

  project_name              = var.project_name
  environment               = var.environment
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  route53_zone_id           = module.route53[0].zone_id
  common_tags               = var.common_tags
}
