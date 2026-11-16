terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

resource "aws_wafv2_web_acl" "main" {
  count = var.enable_paid_resources ? 1 : 0

  provider = aws.us_east_1

  name        = "${var.project_name}-${var.environment}-cloudfront"
  description = "WAF for the CloudFront distribution"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = {
      AWSManagedRulesAmazonIpReputationList = 1
      AWSManagedRulesCommonRuleSet          = 2
      AWSManagedRulesKnownBadInputsRuleSet  = 3
      AWSManagedRulesSQLiRuleSet            = 4
    }

    content {
      name     = rule.key
      priority = rule.value

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.key
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.key
        sampled_requests_enabled   = true
      }
    }
  }

  rule {
    name     = "RateBasedRule"
    priority = 5

    action {
      block {}
    }

    statement {
      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 2000
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateBasedRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-${var.environment}-cloudfront"
    sampled_requests_enabled   = true
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-cloudfront-waf"
  })
}

resource "aws_cloudwatch_log_group" "waf" {
  count = var.enable_paid_resources ? 1 : 0

  provider = aws.us_east_1

  name              = "aws-waf-logs-${var.project_name}-${var.environment}-cloudfront"
  retention_in_days = var.waf_log_retention_days

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-cloudfront-waf-logs"
  })
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count = var.enable_paid_resources ? 1 : 0

  provider = aws.us_east_1

  log_destination_configs = [aws_cloudwatch_log_group.waf[0].arn]
  resource_arn            = aws_wafv2_web_acl.main[0].arn

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }

  redacted_fields {
    single_header {
      name = "cookie"
    }
  }
}

moved {
  from = aws_wafv2_web_acl.main
  to   = aws_wafv2_web_acl.main[0]
}

moved {
  from = aws_cloudwatch_log_group.waf
  to   = aws_cloudwatch_log_group.waf[0]
}

moved {
  from = aws_wafv2_web_acl_logging_configuration.main
  to   = aws_wafv2_web_acl_logging_configuration.main[0]
}
