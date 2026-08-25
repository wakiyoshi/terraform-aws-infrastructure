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

