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
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Purpose     = "TerraformState"
    }
  }
}

variable "project_name" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }

data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${var.project_name}-${var.environment}-terraform-state-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = local.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "require_tls" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.require_tls.json
}

data "aws_iam_policy_document" "require_tls" {
  statement {
    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.terraform_state.arn,
      "${aws_s3_bucket.terraform_state.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

module "github_actions_oidc" {
  source = "../../../modules/bootstrap"

  project_name                  = var.project_name
  environment                   = var.environment
  aws_region                    = var.aws_region
  aws_account_id                = data.aws_caller_identity.current.account_id
  terraform_github_repository   = "wakiyoshi/terraform-aws-infrastructure"
  application_github_repository = "wakiyoshi/grant-application-app"
}

output "terraform_deploy_role_arn" {
  description = "ARN used for this environment's Terraform GitHub Actions variable"
  value       = module.github_actions_oidc.terraform_deploy_role_arn
}

output "application_deploy_role_arn" {
  description = "ARN used for this environment's application GitHub Actions variable"
  value       = module.github_actions_oidc.application_deploy_role_arn
}

output "github_oidc_provider_arn" {
  value = module.github_actions_oidc.github_oidc_provider_arn
}
