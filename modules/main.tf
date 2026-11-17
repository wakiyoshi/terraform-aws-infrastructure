//vpc
module "vpc" {
  source                = "./vpc"
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
  source       = "./s3"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

module "route53" {
  source = "./route53"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  common_tags  = var.common_tags
}

module "acm" {
  count  = var.environment == "prod" || var.enable_paid_resources ? 1 : 0
  source = "./acm"

  project_name              = var.project_name
  environment               = var.environment
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  # 同一アカウント・ドメインの検証CNAMEはリージョン間で共通。管理元を一本化する。
  create_validation_records = false
  validation_record_fqdns   = module.cloudfront_acm.validation_record_fqdns
  route53_zone_id           = module.route53.zone_id
  common_tags               = var.common_tags
}

module "cloudfront_acm" {
  source = "./acm"

  providers = {
    aws = aws.us_east_1
  }

  project_name    = var.project_name
  environment     = var.environment
  domain_name     = var.domain_name
  route53_zone_id = module.route53.zone_id
  common_tags     = var.common_tags
}

module "ses" {
  count  = var.environment == "prod" ? 1 : 0
  source = "./ses"

  project_name    = var.project_name
  environment     = var.environment
  aws_region      = var.aws_region
  domain_name     = var.domain_name
  route53_zone_id = module.route53.zone_id
  common_tags     = var.common_tags
}

module "ecr" {
  source = "./ecr"

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

module "alb" {
  count  = var.enable_paid_resources ? 1 : 0
  source = "./alb"

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

resource "aws_route53_record" "alb_origin" {
  count = var.enable_paid_resources ? 1 : 0

  zone_id = module.route53.zone_id
  name    = "origin.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb[0].dns_name
    zone_id                = module.alb[0].zone_id
    evaluate_target_health = true
  }
}

module "cloudfront" {
  source = "./cloudfront"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  project_name                         = var.project_name
  environment                          = var.environment
  cloudfront_basic_auth                = var.cloudfront_basic_auth
  aliases                              = [var.domain_name]
  acm_certificate_arn                  = module.cloudfront_acm.certificate_arn
  frontend_bucket_id                   = module.s3.buckets["frontend"].id
  frontend_bucket_arn                  = module.s3.buckets["frontend"].arn
  frontend_bucket_regional_domain_name = module.s3.buckets["frontend"].bucket_regional_domain_name
  enable_paid_resources                = var.enable_paid_resources
  enable_alb_origin                    = var.enable_paid_resources
  # Reference the DNS resource directly so only the distribution waits for it.
  alb_origin_domain_name     = var.enable_paid_resources ? trimsuffix(aws_route53_record.alb_origin[0].fqdn, ".") : null
  alb_origin_protocol_policy = "https-only"
  backend_path_pattern       = var.cloudfront_backend_path_pattern
  price_class                = var.cloudfront_price_class
  waf_log_retention_days     = var.log_retention_days
  common_tags                = var.common_tags
}

resource "aws_route53_record" "cloudfront_ipv4" {
  zone_id = module.route53.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_ipv6" {
  zone_id = module.route53.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

# ECSを有効にした場合だけ、ECRの最新push済みイメージを取得する。
data "aws_ecr_image" "bootstrap" {
  count = var.enable_paid_resources ? 1 : 0

  repository_name = module.ecr.repository_name
  most_recent     = true
}

module "ecs" {
  count  = var.enable_paid_resources ? 1 : 0
  source = "./ecs"

  project_name             = var.project_name
  environment              = var.environment
  aws_region               = var.aws_region
  common_tags              = var.common_tags
  private_subnet_ids       = module.vpc.private_subnet_ids
  ecs_security_group_id    = module.vpc.ecs_security_group_id
  target_group_arn         = module.alb[0].target_group_arn
  ecr_repository_url       = module.ecr.repository_url
  bootstrap_image_digest   = data.aws_ecr_image.bootstrap[0].image_digest
  container_name           = var.container_name
  application_port         = var.application_port
  task_cpu                 = var.task_cpu
  task_memory              = var.task_memory
  desired_count            = var.desired_count
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
  autoscaling_cpu_target   = var.autoscaling_cpu_target
  log_retention_days       = var.log_retention_days
  container_environment = merge(var.container_environment, {
    AWS_BUCKET         = module.s3.buckets["attachments"].id
    AWS_DEFAULT_REGION = var.aws_region
    DB_CONNECTION      = "mysql"
    DB_HOST            = module.rds[0].endpoint
    DB_PORT            = tostring(module.rds[0].port)
    DB_DATABASE        = var.database_name
  })
  database_secret_arn  = module.rds[0].master_user_secret_arn
  container_secrets    = var.container_secrets
  database_kms_key_arn = module.rds_secrets_kms.key_arn

  # NAT GatewayとPrivate Routeの作成完了後にServiceを起動する
  depends_on = [module.vpc]
}

data "aws_iam_policy_document" "ecs_ses_send" {
  count = var.environment == "prod" && var.enable_paid_resources ? 1 : 0

  statement {
    sid    = "SendEmailFromSiteDomain"
    effect = "Allow"

    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = [module.ses[0].identity_arn]

    condition {
      test     = "StringLike"
      variable = "ses:FromAddress"
      values   = ["*@${var.domain_name}"]
    }
  }
}

resource "aws_iam_role_policy" "ecs_ses_send" {
  count = var.environment == "prod" && var.enable_paid_resources ? 1 : 0

  name   = "${var.project_name}-${var.environment}-ses-send"
  role   = module.ecs[0].task_role_name
  policy = data.aws_iam_policy_document.ecs_ses_send[0].json
}

module "rds_secrets_kms" {
  source = "./kms"

  # KMS Keyの削除予約によるSecret復号不能を避けるため、Aurora OFF時も保持する
  project_name            = var.project_name
  environment             = var.environment
  alias_suffix            = "rds-secrets"
  description             = "KMS key for ${var.project_name}-${var.environment} RDS master credentials"
  deletion_window_in_days = var.kms_deletion_window_in_days
  common_tags             = var.common_tags
}

module "rds" {
  count  = var.enable_paid_resources ? 1 : 0
  source = "./rds"

  project_name                        = var.project_name
  environment                         = var.environment
  private_subnet_ids                  = module.vpc.private_subnet_ids
  rds_security_group_id               = module.vpc.rds_security_group_id
  common_tags                         = var.common_tags
  database_name                       = var.database_name
  master_username                     = var.database_master_username
  master_user_secret_kms_key_id       = module.rds_secrets_kms.key_arn
  engine_version                      = var.aurora_engine_version
  instance_count                      = var.rds_instance_count
  serverless_min_capacity             = var.aurora_serverless_min_capacity
  serverless_max_capacity             = var.aurora_serverless_max_capacity
  backup_retention_period             = var.rds_backup_retention_period
  preferred_backup_window             = var.rds_preferred_backup_window
  preferred_maintenance_window        = var.rds_preferred_maintenance_window
  deletion_protection                 = var.rds_deletion_protection
  skip_final_snapshot                 = var.rds_skip_final_snapshot
  apply_immediately                   = var.rds_apply_immediately
  performance_insights_enabled        = var.rds_performance_insights_enabled
  iam_database_authentication_enabled = var.rds_iam_database_authentication_enabled
}

module "rds_secret_policy" {
  count  = var.enable_paid_resources ? 1 : 0
  source = "./secrets_manager"

  secret_arn = module.rds[0].master_user_secret_arn
}

module "sns" {
  count  = length(var.cloudwatch_alarm_email_addresses) > 0 ? 1 : 0
  source = "./sns"

  project_name    = var.project_name
  environment     = var.environment
  common_tags     = var.common_tags
  email_addresses = var.cloudwatch_alarm_email_addresses
}

module "cloudwatch" {
  count  = var.enable_paid_resources ? 1 : 0
  source = "./cloudwatch"

  project_name            = var.project_name
  environment             = var.environment
  common_tags             = var.common_tags
  ecs_cluster_name        = module.ecs[0].cluster_name
  ecs_service_name        = module.ecs[0].service_name
  alb_arn_suffix          = module.alb[0].arn_suffix
  target_group_arn_suffix = module.alb[0].target_group_arn_suffix
  rds_cluster_id          = module.rds[0].cluster_id
  alarm_actions           = distinct(concat(var.cloudwatch_alarm_actions, module.sns[*].topic_arn))
}

module "security_baseline" {
  source = "./security_baseline"

  project_name                  = var.project_name
  environment                   = var.environment
  common_tags                   = var.common_tags
  include_global_resource_types = var.config_include_global_resource_types
}

moved {
  from = module.security_baseline[0]
  to   = module.security_baseline
}

module "cloudtrail" {
  source = "./cloudtrail"

  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

# 添付ファイルへのアクセスはアプリ用Task Roleに限定する。
resource "aws_iam_role_policy" "ecs_attachments" {
  count = var.enable_paid_resources ? 1 : 0

  name = "${var.project_name}-${var.environment}-attachments"
  role = module.ecs[0].task_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = module.s3.buckets["attachments"].arn
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:AbortMultipartUpload"]
        Resource = "${module.s3.buckets["attachments"].arn}/*"
      },
    ]
  })
}
