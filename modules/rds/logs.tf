# Export先の保持期間を管理する。既に自動作成済みならimportしてからapplyする。
resource "aws_cloudwatch_log_group" "database" {
  for_each = toset(["error", "slowquery", "audit"])

  name              = "/aws/rds/cluster/${var.project_name}-${var.environment}-aurora/${each.key}"
  retention_in_days = var.log_retention_days
  tags              = var.common_tags
}
