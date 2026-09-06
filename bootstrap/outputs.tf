output "state_bucket_name" {
  description = "S3 bucket name to set in the root backend configuration"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_region" {
  description = "AWS Region of the Terraform State bucket"
  value       = var.aws_region
}
