data "aws_caller_identity" "current" {}

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

module "ecr" {
  count  = var.environment == "prod" ? 1 : 0
  source = "./container/ecr"

  project_name                   = var.project_name
  common_tags                    = var.common_tags
  keep_image_count               = var.keep_image_count
  untagged_image_expiration_days = var.untagged_image_expiration_days
}

module "alb" {
  count  = var.enable_paid_resources ? 1 : 0
  source = "./network/alb"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  common_tags           = var.common_tags
  alb_security_group_id = module.vpc.alb_security_group_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  certificate_arn       = try(module.acm[0].certificate_arn, null)
  ssl_policy            = var.ssl_policy
  application_port      = var.application_port
  health_check_path     = var.health_check_path
}

module "ecs" {
  count  = var.enable_paid_resources ? 1 : 0
  source = "./container/ecs"

  project_name          = var.project_name
  environment           = var.environment
  aws_region            = var.aws_region
  common_tags           = var.common_tags
  private_subnet_ids    = module.vpc.private_subnet_ids
  ecs_security_group_id = module.vpc.ecs_security_group_id
  target_group_arn      = module.alb[0].target_group_arn
  ecr_repository_url = try(
    module.ecr[0].repository_url,
    "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.project_name}-app"
  )
  image_tag                = var.image_tag
  container_name           = var.container_name
  application_port         = var.application_port
  task_cpu                 = var.task_cpu
  task_memory              = var.task_memory
  desired_count            = var.desired_count
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
  autoscaling_cpu_target   = var.autoscaling_cpu_target
  log_retention_days       = var.log_retention_days
  container_environment    = var.container_environment
}
