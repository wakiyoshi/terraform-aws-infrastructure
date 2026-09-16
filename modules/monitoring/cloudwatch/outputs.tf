output "alarm_arns" {
  description = "CloudWatch alarm ARNs keyed by monitored metric"
  value       = { for name, alarm in aws_cloudwatch_metric_alarm.main : name => alarm.arn }
}
