module "main" {
  source = "../../modules"

  project_name                  = var.project_name
  environment                   = var.environment
  frontend_bucket_name          = var.frontend_bucket_name
  frontend_bucket_force_destroy = var.frontend_bucket_force_destroy
  common_tags                   = local.common_tags
}

# Preserve existing resources when moving the S3 module into the shared module.
moved {
  from = module.s3
  to   = module.main.module.s3
}
