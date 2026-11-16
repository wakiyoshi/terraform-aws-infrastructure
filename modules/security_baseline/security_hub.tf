# Security Hub CSPM creates the service-linked Config rules required by its
# default standards. Their compliance results appear as control findings;
# configuration history remains in AWS Config.
resource "aws_securityhub_account" "main" {
  enable_default_standards  = true
  auto_enable_controls      = true
  control_finding_generator = "SECURITY_CONTROL"

  depends_on = [aws_config_configuration_recorder_status.main]
}

resource "aws_securityhub_product_subscription" "guardduty" {
  product_arn = "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.region}::product/aws/guardduty"

  depends_on = [aws_securityhub_account.main, aws_guardduty_detector.main]
}

resource "aws_securityhub_product_subscription" "inspector" {
  product_arn = "arn:${data.aws_partition.current.partition}:securityhub:${data.aws_region.current.region}::product/aws/inspector"

  depends_on = [aws_securityhub_account.main, aws_ecr_registry_scanning_configuration.main]
}
