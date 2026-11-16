variable "project_name" { type = string }
variable "environment" { type = string }
variable "ecs_cluster_name" { type = string }
variable "ecs_service_name" { type = string }
variable "alb_arn_suffix" { type = string }
variable "target_group_arn_suffix" { type = string }
variable "rds_cluster_id" { type = string }
variable "common_tags" {
  type    = map(string)
  default = {}
}
variable "alarm_actions" {
  description = "SNS topic ARNs in the same Region for alarm and recovery notifications"
  type        = list(string)
  default     = []
}
