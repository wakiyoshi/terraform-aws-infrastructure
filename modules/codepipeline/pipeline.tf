resource "aws_codepipeline" "main" {
  name           = "${var.project_name}-${var.environment}-pipeline"
  role_arn       = aws_iam_role.codepipeline.arn
  #標準で安価
  pipeline_type  = "V1"
  #新しいpipelineの実行を開始時に、古い実行をキャンセルする
  execution_mode = "SUPERSEDED"

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "GitHubSource"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.github_repository
        BranchName       = var.github_branch
        DetectChanges    = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "BuildAndPushImage"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployToECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName       = var.ecs_cluster_name
        ServiceName       = var.ecs_service_name
        FileName          = "imagedefinitions.json"
        DeploymentTimeout = tostring(var.deployment_timeout_minutes)
      }
    }
  }

  tags = var.common_tags

  depends_on = [
    aws_s3_bucket_versioning.artifacts,
    aws_s3_bucket_server_side_encryption_configuration.artifacts,
    aws_s3_bucket_public_access_block.artifacts,
    aws_iam_role_policy.codepipeline
  ]
}
