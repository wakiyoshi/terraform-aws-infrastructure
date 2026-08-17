variable "project_name" {
  description = "Project name used as a resource name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository in owner/repository format"
  type        = string

  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "github_repository must use the owner/repository format."
  }
}

variable "github_branch" {
  description = "GitHub branch monitored by CodePipeline"
  type        = string
  default     = "main"
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project run by the pipeline"
  type        = string
}

variable "codebuild_project_arn" {
  description = "ARN of the CodeBuild project run by the pipeline"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster to deploy to"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service to update"
  type        = string
}

variable "ecs_service_arn" {
  description = "ARN of the ECS service to update"
  type        = string
}

variable "ecs_task_role_arns" {
  description = "Task role and task execution role ARNs passed when CodePipeline registers a task definition revision"
  type        = list(string)

  validation {
    condition     = length(var.ecs_task_role_arns) > 0
    error_message = "ecs_task_role_arns must contain at least one role ARN."
  }
}

variable "deployment_timeout_minutes" {
  description = "Maximum time the ECS deploy action waits for deployment completion"
  type        = number
  default     = 15

  validation {
    condition     = var.deployment_timeout_minutes >= 5 && var.deployment_timeout_minutes <= 60
    error_message = "deployment_timeout_minutes must be between 5 and 60."
  }
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
  default     = {}
}
