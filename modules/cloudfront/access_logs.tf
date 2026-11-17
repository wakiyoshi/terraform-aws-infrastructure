# Standard logging v2: ACLを有効化する旧S3配信方式は使わない。
resource "aws_cloudwatch_log_group" "access" {
  provider = aws.us_east_1

  name              = "/aws/cloudfront/${var.project_name}/${var.environment}/access"
  retention_in_days = var.waf_log_retention_days
  tags              = var.common_tags
}

resource "aws_cloudwatch_log_delivery_source" "access" {
  provider = aws.us_east_1

  name         = "${var.project_name}-${var.environment}-cloudfront"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.main.arn
}

resource "aws_cloudwatch_log_delivery_destination" "access" {
  provider = aws.us_east_1

  name          = "${var.project_name}-${var.environment}-cloudfront"
  output_format = "json"
  delivery_destination_configuration {
    destination_resource_arn = aws_cloudwatch_log_group.access.arn
  }
}

resource "aws_cloudwatch_log_delivery" "access" {
  provider = aws.us_east_1

  delivery_source_name     = aws_cloudwatch_log_delivery_source.access.name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.access.arn
  # Cookie・クエリ文字列・認証ヘッダーは記録しない。
  record_fields = ["date", "time", "c-ip", "cs-method", "cs(Host)", "cs-uri-stem", "sc-status", "time-taken", "x-edge-result-type"]
}
