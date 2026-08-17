output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.main.name
}

output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.main.arn
}

output "artifact_bucket_name" {
  description = "Name of the pipeline artifact bucket"
  value       = aws_s3_bucket.artifacts.bucket
}

output "github_connection_arn" {
  description = "ARN of the GitHub CodeConnections connection"
  value       = aws_codestarconnections_connection.github.arn
}
