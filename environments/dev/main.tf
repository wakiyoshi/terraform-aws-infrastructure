module "main" {
  source = "../../modules"

  project_name                  = var.project_name
  environment                   = var.environment
  aws_region                    = var.aws_region
  vpc_cidr                      = var.vpc_cidr
  availability_zones            = var.availability_zones
  application_port              = var.application_port
  domain_name                   = var.domain_name
  frontend_bucket_name          = var.frontend_bucket_name
  frontend_bucket_force_destroy = var.frontend_bucket_force_destroy
  common_tags                   = local.common_tags
  enable_paid_resources         = var.enable_paid_resources
}
