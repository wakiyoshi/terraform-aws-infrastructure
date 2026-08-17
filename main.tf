//moduleの呼び出し、varの受け渡し。

module "network" {
  source = "./modules/network"

  project_name = var.project_name
  environment  = var.environment
  availability_zones = var.availability_zones
  vpc_cidr     = var.vpc_cidr
  common_tags  = local.common_tags
  application_port = var.application_port
}

module "route53" {
  source = "./modules/route53"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  common_tags  = local.common_tags

  alb_dns_name = module.alb.dns_name
  alb_zone_id  = module.alb.zone_id
}

module "acm" {
  source = "./modules/acm"

  project_name    = var.project_name
  environment     = var.environment
  domain_name     = var.domain_name
  route53_zone_id = module.route53.zone_id
  common_tags     = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.network.alb_security_group_id

  vpc_cidr     = var.vpc_cidr
  common_tags  = local.common_tags

  availability_zones = var.availability_zones
  application_port = var.application_port
  certificate_arn = module.acm.certificate_arn
}
