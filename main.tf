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

  certificate_arn = module.acm.certificate_arn
}
