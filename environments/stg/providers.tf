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
  allowed_account_ids = ["721563685066"]
  region              = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  alias               = "us_east_1"
  allowed_account_ids = ["721563685066"]
  region              = "us-east-1"

  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
