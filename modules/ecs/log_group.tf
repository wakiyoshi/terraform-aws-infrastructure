resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${var.project_name}/${var.environment}/app"
  //ログの保存時間
  retention_in_days = var.log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-ecs-log"
    }
  )
}
