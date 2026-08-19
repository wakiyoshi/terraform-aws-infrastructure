# AWS ECS Infrastructure

Terraformを使用してAWS上にWebアプリケーション基盤を構築するプロジェクトです。

## Architecture

主な構成：

- Route 53
- CloudFront
- WAF
- ALB
- ECS Fargate
- ECR
- Aurora MySQL
- S3
- CloudWatch
- CodePipeline
- CodeBuild

### Traffic Flow

Frontend:

User
→ Route 53
→ CloudFront
→ S3

Backend:

User
→ Route 53
→ CloudFront
→ ALB
→ ECS Fargate
→ Aurora MySQL

## Directory Structure

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── vpc.tf
├── alb.tf
├── ecs.tf
├── ecr.tf
├── rds.tf
├── s3.tf
├── cloudfront.tf
├── iam.tf
├── codepipeline.tf
├── terraform.tfvars
└── README.md