data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_partition" "current" {}

locals {
  trail_name = "${var.project_name}-${var.environment}-cloudtrail"
  trail_arn  = "arn:${data.aws_partition.current.partition}:cloudtrail:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:trail/${local.trail_name}"
}

resource "aws_cloudtrail" "main" {
  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.logs.id
  enable_logging                = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true
  is_organization_trail         = false

  # Management events and object operations across all S3 buckets.
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:${data.aws_partition.current.partition}:s3"]
    }
  }

  tags = var.common_tags

  depends_on = [
    aws_s3_bucket_policy.logs,
    aws_s3_bucket_public_access_block.logs,
    aws_s3_bucket_ownership_controls.logs,
    aws_s3_bucket_versioning.logs,
    aws_s3_bucket_server_side_encryption_configuration.logs,
  ]
}
