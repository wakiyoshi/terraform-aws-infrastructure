locals {
  alarms = {
    ecs_cpu = {
      namespace          = "AWS/ECS"
      metric_name        = "CPUUtilization"
      statistic          = "Average"
      threshold          = 80
      evaluation_periods = 3
      treat_missing_data = "missing"
      dimensions         = { ClusterName = var.ecs_cluster_name, ServiceName = var.ecs_service_name }
    }
    ecs_memory = {
      namespace          = "AWS/ECS"
      metric_name        = "MemoryUtilization"
      statistic          = "Average"
      threshold          = 80
      evaluation_periods = 3
      treat_missing_data = "missing"
      dimensions         = { ClusterName = var.ecs_cluster_name, ServiceName = var.ecs_service_name }
    }
    alb_unhealthy_hosts = {
      namespace          = "AWS/ApplicationELB"
      metric_name        = "UnHealthyHostCount"
      statistic          = "Maximum"
      threshold          = 1
      evaluation_periods = 2
      treat_missing_data = "missing"
      dimensions         = { LoadBalancer = var.alb_arn_suffix, TargetGroup = var.target_group_arn_suffix }
    }
    alb_5xx = {
      namespace          = "AWS/ApplicationELB"
      metric_name        = "HTTPCode_ELB_5XX_Count"
      statistic          = "Sum"
      threshold          = 10
      evaluation_periods = 1
      treat_missing_data = "notBreaching"
      dimensions         = { LoadBalancer = var.alb_arn_suffix }
    }
    target_5xx = {
      namespace          = "AWS/ApplicationELB"
      metric_name        = "HTTPCode_Target_5XX_Count"
      statistic          = "Sum"
      threshold          = 10
      evaluation_periods = 1
      treat_missing_data = "notBreaching"
      dimensions         = { LoadBalancer = var.alb_arn_suffix, TargetGroup = var.target_group_arn_suffix }
    }
    rds_cpu = {
      namespace          = "AWS/RDS"
      metric_name        = "CPUUtilization"
      statistic          = "Maximum"
      threshold          = 80
      evaluation_periods = 3
      treat_missing_data = "missing"
      dimensions         = { DBClusterIdentifier = var.rds_cluster_id }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "main" {
  for_each = local.alarms

  alarm_name          = "${var.project_name}-${var.environment}-${replace(each.key, "_", "-")}"
  alarm_description   = "${each.value.metric_name} >= ${each.value.threshold} for ${each.value.evaluation_periods} consecutive 5-minute periods"
  namespace           = each.value.namespace
  metric_name         = each.value.metric_name
  statistic           = each.value.statistic
  dimensions          = each.value.dimensions
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = each.value.threshold
  period              = 300
  evaluation_periods  = each.value.evaluation_periods
  datapoints_to_alarm = each.value.evaluation_periods
  treat_missing_data  = each.value.treat_missing_data
  alarm_actions       = var.alarm_actions
  ok_actions          = var.alarm_actions
  tags                = var.common_tags
}
