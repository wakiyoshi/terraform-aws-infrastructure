resource "aws_codebuild_project" "main" {
  name         = "${var.project_name}-${var.environment}-build"
  service_role = aws_iam_role.codebuild.arn

  #CodeBuildの成果物をどこで管理・受け渡すかを指定
  artifacts {
    type = "CODEPIPELINE"
  }

  #CodeBuildを動かす「実行環境」全体の設定
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"

    # CodeBuildの実行環境イメージを取得するとき、CodeBuild側の認証情報を使う
    image_pull_credentials_type = "CODEBUILD"

    # CodeBuild内でDockerを使えるようにする設定です。
    privileged_mode             = true

    # ログイン用
    environment_variable {
      name  = "ECR_REGISTRY"
      value = split("/", var.ecr_repository_url)[0]
    }

    environment_variable {
      name  = "ECR_REPOSITORY_URL"
      value = var.ecr_repository_url
    }

    #タスク定義に定義されているアプリコンテナの名前、imagedefinition.jsonに更新する必要がある
    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }
  }
  # pipelineからソースを受け取ってリポジトリの中のbuildspec.ymlを使ってビルドする
  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = var.common_tags
}