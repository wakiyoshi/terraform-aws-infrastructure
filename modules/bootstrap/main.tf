locals {
  terraform_role_name   = "terraform-gha-${var.environment}-deploy-role"
  application_role_name = "application-gha-${var.environment}-deploy-role"

  ecr_repository_name = var.environment == "prod" ? "${var.project_name}-app" : "${var.project_name}-${var.environment}-app"
  ecs_cluster_name    = "${var.project_name}-${var.environment}-cluster"
  ecs_service_name    = "${var.project_name}-${var.environment}-service"
  ecs_task_family     = "${var.project_name}-${var.environment}-task"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
  ]

  tags = {
    Name    = "github-actions-oidc"
    Purpose = "GitHubActionsOIDC"
  }
}

data "aws_iam_policy_document" "terraform_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.terraform_github_repository}:ref:refs/heads/main",
        "repo:${var.terraform_github_repository}:environment:${upper(var.environment)}",
      ]
    }
  }
}

resource "aws_iam_role" "terraform_deploy" {
  name                 = local.terraform_role_name
  assume_role_policy   = data.aws_iam_policy_document.terraform_assume_role.json
  max_session_duration = 3600

  tags = {
    Name    = local.terraform_role_name
    Purpose = "TerraformGitHubActions"
  }
}

resource "aws_iam_role_policy_attachment" "terraform_power_user_access" {
  role       = aws_iam_role.terraform_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data "aws_iam_policy_document" "terraform_project_iam" {
  statement {
    sid    = "ManageProjectRoles"
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy",
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:ListRoleTags",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
    ]
    resources = ["arn:aws:iam::${var.aws_account_id}:role/${var.project_name}-${var.environment}-*"]
  }

  statement {
    sid       = "ReadAWSManagedPolicies"
    effect    = "Allow"
    actions   = ["iam:GetPolicy"]
    resources = ["arn:aws:iam::aws:policy/*"]
  }
}

resource "aws_iam_role_policy" "terraform_project_iam" {
  name   = "${local.terraform_role_name}-project-iam"
  role   = aws_iam_role.terraform_deploy.id
  policy = data.aws_iam_policy_document.terraform_project_iam.json
}

data "aws_iam_policy_document" "application_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.application_github_repository}:environment:${var.environment}"]
    }
  }
}

resource "aws_iam_role" "application_deploy" {
  name                 = local.application_role_name
  assume_role_policy   = data.aws_iam_policy_document.application_assume_role.json
  max_session_duration = 3600

  tags = {
    Name    = local.application_role_name
    Purpose = "ApplicationGitHubActions"
  }
}

data "aws_iam_policy_document" "application_deploy" {
  statement {
    sid       = "ECRAuthorization"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "EnvironmentECRRepository"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
    resources = ["arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/${local.ecr_repository_name}"]
  }

  statement {
    sid    = "ECSReadAndRegisterTaskDefinition"
    effect = "Allow"
    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:ListTaskDefinitions",
      "ecs:RegisterTaskDefinition",
      "ecs:TagResource",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EnvironmentECSService"
    effect = "Allow"
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
    ]
    resources = ["arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:service/${local.ecs_cluster_name}/${local.ecs_service_name}"]
  }

  statement {
    sid       = "RunEnvironmentTaskDefinition"
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:task-definition/${local.ecs_task_family}:*"]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = ["arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:cluster/${local.ecs_cluster_name}"]
    }
  }

  statement {
    sid       = "DescribeEnvironmentTasks"
    effect    = "Allow"
    actions   = ["ecs:DescribeTasks"]
    resources = ["arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:task/${local.ecs_cluster_name}/*"]
  }

  statement {
    sid     = "PassEnvironmentECSTaskRoles"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::${var.aws_account_id}:role/${var.project_name}-${var.environment}-ecs-task-execution-role",
      "arn:aws:iam::${var.aws_account_id}:role/${var.project_name}-${var.environment}-ecs-task-role",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "application_deploy" {
  name   = "${local.application_role_name}-policy"
  role   = aws_iam_role.application_deploy.id
  policy = data.aws_iam_policy_document.application_deploy.json
}
