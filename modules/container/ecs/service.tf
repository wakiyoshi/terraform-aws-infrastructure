resource "aws_ecs_service" "main" {
  name    = "${var.project_name}-${var.environment}-service"
  cluster = aws_ecs_cluster.main.id

  //同じモジュール内だから直接参照可能
  task_definition = aws_ecs_task_definition.main.arn
  //常に起動しておくタスクの数
  desired_count = var.desired_count

  launch_type      = "FARGATE"
  platform_version = "LATEST"

  // ローリングデプロイ関連設定
  // デプロイ中も desired_count の100%を維持する
  deployment_minimum_healthy_percent = 100
  // デプロイ中に desired_count の200%まで起動する
  deployment_maximum_percent = 200

  // 起動時ヘルスチェック失敗時にロールバック
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  // 起動直後のタスクをALBが異常判定するまでの猶予
  health_check_grace_period_seconds = 60


  //ENIを作成するための設定　FARGATEがENIをこの情報をもとに作成する、これを設定しないとFARGATEが起動しない
  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  //ALBのtarget groupにタスクのportとコンテナ名を登録するための設定
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.application_port
  }

  //managed tagsを有効化することで自動でタグ付け
  enable_ecs_managed_tags = true
  // ECSサービスのタグ名をタスク名に引き継ぐ
  propagate_tags = "SERVICE"

  //ポリシーがアタッチされる前にECS Serviceを作らないように
  depends_on = [
    aws_iam_role_policy_attachment.task_execution
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-service"
    }
  )

  // Terraformのリソースの作成・更新・削除方法を制御する設定です。
  lifecycle {
    # Auto Scalingがdesired_countを変更するため、
    # Terraformとの差分として扱わない autoスケールした際に差分を無視
    ignore_changes = [
      desired_count
    ]
  }
}