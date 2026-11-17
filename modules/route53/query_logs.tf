data "aws_caller_identity" "logs" {}

# Public hosted zoneのクエリログはus-east-1に保存する。
resource "aws_cloudwatch_log_group" "queries" {
  provider = aws.us_east_1

  name              = "/aws/route53/${var.project_name}/${var.environment}"
  retention_in_days = var.log_retention_days
  tags              = var.common_tags
}

resource "aws_cloudwatch_log_resource_policy" "queries" {
  provider = aws.us_east_1

  policy_name = "${var.project_name}-${var.environment}-dns-query-logs"
  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "route53.amazonaws.com" }
      Action    = ["logs:CreateLogStream", "logs:PutLogEvents"]
      Resource  = "${aws_cloudwatch_log_group.queries.arn}:*"
      Condition = {
        StringEquals = { "aws:SourceAccount" = data.aws_caller_identity.logs.account_id }
        ArnEquals    = { "aws:SourceArn" = aws_route53_zone.main.arn }
      }
    }]
  })
}

resource "aws_route53_query_log" "main" {
  provider = aws.us_east_1

  cloudwatch_log_group_arn = aws_cloudwatch_log_group.queries.arn
  zone_id                  = aws_route53_zone.main.zone_id
  depends_on               = [aws_cloudwatch_log_resource_policy.queries]
}
