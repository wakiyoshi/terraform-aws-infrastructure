terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

module "s3" {
  source = "./storage/s3"

  project_name  = var.project_name
  environment   = var.environment
  bucket_name   = var.frontend_bucket_name
  force_destroy = var.frontend_bucket_force_destroy
  common_tags   = var.common_tags
}
