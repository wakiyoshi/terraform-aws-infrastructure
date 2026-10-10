module "main" {
  source = "../../modules"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  config_include_global_resource_types = var.config_include_global_resource_types

  project_name                     = var.project_name
  environment                      = var.environment
  aws_region                       = var.aws_region
  vpc_cidr                         = var.vpc_cidr
  availability_zones               = var.availability_zones
  application_port                 = var.application_port
  domain_name                      = var.domain_name
  frontend_bucket_name             = var.frontend_bucket_name
  frontend_bucket_force_destroy    = var.frontend_bucket_force_destroy
  common_tags                      = local.common_tags
  enable_paid_resources            = var.enable_paid_resources
  keep_image_count                 = var.keep_image_count
  untagged_image_expiration_days   = var.untagged_image_expiration_days
  ssl_policy                       = var.ssl_policy
  health_check_path                = var.health_check_path
  container_name                   = var.container_name
  task_cpu                         = var.task_cpu
  task_memory                      = var.task_memory
  desired_count                    = var.desired_count
  autoscaling_min_capacity         = var.autoscaling_min_capacity
  autoscaling_max_capacity         = var.autoscaling_max_capacity
  autoscaling_cpu_target           = var.autoscaling_cpu_target
  cloudwatch_alarm_actions         = var.cloudwatch_alarm_actions
  cloudwatch_alarm_email_addresses = var.cloudwatch_alarm_email_addresses
  log_retention_days               = var.log_retention_days
  container_environment            = var.container_environment
  container_secrets = merge(var.container_secrets, {
    APP_KEY = aws_secretsmanager_secret.app_key.arn
  })
  database_name                  = var.database_name
  database_master_username       = var.database_master_username
  aurora_engine_version          = var.aurora_engine_version
  rds_instance_count             = var.rds_instance_count
  aurora_serverless_min_capacity = var.aurora_serverless_min_capacity
  aurora_serverless_max_capacity = var.aurora_serverless_max_capacity
  rds_backup_retention_period    = var.rds_backup_retention_period
  rds_deletion_protection        = var.rds_deletion_protection
  rds_skip_final_snapshot        = var.rds_skip_final_snapshot
}
