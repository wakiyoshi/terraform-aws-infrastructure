//moduleの呼び出し、varの受け渡し。

module "network" {
  source = "./modules/network"

  project_name       = var.project_name
  environment        = var.environment
  availability_zones = var.availability_zones
  vpc_cidr           = var.vpc_cidr
  common_tags        = local.common_tags
  application_port   = var.application_port
}

module "route53" {
  source = "./modules/route53"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  common_tags  = local.common_tags
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

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.network.alb_security_group_id

  vpc_cidr    = var.vpc_cidr
  common_tags = local.common_tags

  availability_zones = var.availability_zones
  application_port   = var.application_port
  certificate_arn    = module.acm.certificate_arn
}

module "s3" {
  source = "./modules/s3"

  project_name  = var.project_name
  environment   = var.environment
  bucket_name   = var.frontend_bucket_name
  force_destroy = var.frontend_bucket_force_destroy
  common_tags   = local.common_tags
}

module "cloudfront" {
  source = "./modules/cloudfront"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project_name = var.project_name
  environment  = var.environment

  frontend_bucket_id                   = module.s3.bucket_id
  frontend_bucket_arn                  = module.s3.bucket_arn
  frontend_bucket_regional_domain_name = module.s3.bucket_regional_domain_name

  alb_origin_domain_name = var.domain_name
  backend_path_pattern   = var.backend_path_pattern
  price_class            = var.cloudfront_price_class
  common_tags            = local.common_tags

  depends_on = [aws_route53_record.alb]
}

# Hosted Zoneの作成をALBレコードから分離し、
# Route 53 -> ALB -> ACM -> Route 53の依存サイクルを避ける。
resource "aws_route53_record" "alb" {
  zone_id = module.route53.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}
