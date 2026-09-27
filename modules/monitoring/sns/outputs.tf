output "topic_arn" {
  description = "SNS topic ARN for CloudWatch alarm and recovery notifications"
  value       = aws_sns_topic.alarms.arn
}
