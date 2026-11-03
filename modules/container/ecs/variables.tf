variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where ECS tasks run"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID attached to ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "bootstrap_image_digest" {
  description = "ECR image digest used for initial ECS service creation"
  type        = string
}

variable "container_name" {
  description = "ECS container name"
  type        = string
  default     = "app"
}

variable "application_port" {
  description = "Application container port"
  type        = number
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "Initial number of ECS tasks"
  type        = number
  default     = 2
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 2
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 4
}

variable "autoscaling_cpu_target" {
  description = "Target average CPU utilization"
  type        = number
  default     = 60
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period"
  type        = number
  default     = 30
}

variable "container_environment" {
  description = "Non-sensitive environment variables passed to the container"
  type        = map(string)
  default     = {}
}

variable "database_secret_arn" {
  description = "RDS-managed secret containing username and password"
  type        = string
}

variable "container_secrets" {
  description = "Environment variable names mapped to Secrets Manager valueFrom references"
  type        = map(string)
  default     = {}
}

variable "database_kms_key_arn" {
  description = "KMS key encrypting the RDS-managed secret"
  type        = string
}
