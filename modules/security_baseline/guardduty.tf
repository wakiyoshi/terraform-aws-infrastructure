# Enable regional threat detection with AWS default protection settings.
resource "aws_guardduty_detector" "main" {
  enable = true
  tags   = var.common_tags
}
