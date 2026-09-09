resource "aws_ecs_task_definition" "main" {
  // 名前
  family = "${var.project_name}-${var.environment}-task"

  // FARGATEで起動するための設定
  requires_compatibilities = ["FARGATE"]

  // タスク自身がVPC内で1つのネットワークインターフェース（ENI）とプライベートIPアドレスを持つ
  network_mode = "awsvpc"

  // タスクのCPUとメモリの設定
  cpu    = var.task_cpu
  memory = var.task_memory

  // タスク実行ロールとタスクロールの設定 モジュール内部から参照
  execution_role_arn = aws_iam_role.task_execution.arn
  task_role_arn      = aws_iam_role.task.arn


  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  // コンテナ1台をどう起動するかを定義

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          name          = "application"
          containerPort = var.application_port
          hostPort      = var.application_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      environment = concat(
        [
          {
            name  = "APP_ENV"
            value = var.environment
          }
        ],
        [
          for name, value in var.container_environment : {
            name  = name
            value = value
          }
        ]
      )

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = var.container_name
        }
      }
    }
  ])

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-task"
    }
  )
}