terraform {
  required_version = "~> 1.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = local.common_tags
  }
}

variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "application_port" { type = number }
variable "domain_name" { type = string }
variable "frontend_bucket_name" {
  type    = string
  default = null
}
variable "frontend_bucket_force_destroy" {
  type    = bool
  default = false
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "s3" {
  source = "../../modules/storage/s3"

  project_name  = var.project_name
  environment   = var.environment
  bucket_name   = var.frontend_bucket_name
  force_destroy = var.frontend_bucket_force_destroy
  common_tags   = local.common_tags
}
