data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${var.project_name}-${var.environment}-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json

  tags = var.common_tags
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid    = "ArtifactBucket"
    effect = "Allow"
    actions = [
      "s3:GetBucketVersioning",
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.artifacts.arn]
  }

  statement {
    sid    = "ArtifactObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.artifacts.arn}/*"]
  }

  statement {
    sid       = "GitHubConnection"
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [aws_codestarconnections_connection.github.arn]
  }

  statement {
    sid    = "RunCodeBuild"
    effect = "Allow"
    actions = [
      "codebuild:StartBuild",
      "codebuild:BatchGetBuilds"
    ]
    resources = [var.codebuild_project_arn]
  }

  statement {
    sid    = "TaskDefinition"
    effect = "Allow"
    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ECSService"
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]
    resources = [var.ecs_service_arn]
  }

  statement {
    sid       = "TagTaskDefinition"
    effect    = "Allow"
    actions   = ["ecs:TagResource"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ecs:CreateAction"
      values   = ["RegisterTaskDefinition"]
    }
  }

  statement {
    sid       = "PassECSTaskRoles"
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = var.ecs_task_role_arns

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "codepipeline" {
  name   = "${var.project_name}-${var.environment}-codepipeline-policy"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline.json
}
