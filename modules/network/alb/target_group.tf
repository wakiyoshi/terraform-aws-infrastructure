# modules/network/alb/target_group.tf

resource "aws_lb_target_group" "main" {
  name = "${var.project_name}-${var.environment}-tg"

  //ALBとECSが同じVPCにある必要があるため指定します。
  vpc_id      = var.vpc_id
  port        = var.application_port
  protocol    = "HTTP"
  target_type = "ip"

  # ALBからターゲットへの通信方式
  protocol_version = "HTTP1"

  # ECSのローリング更新時に、古いタスクへの接続を少し待ってから切る
  deregistration_delay = 30

  health_check {
    enabled = true

    path     = var.health_check_path
    port     = "traffic-port"
    protocol = "HTTP"

    # ヘルスチェック専用URLは200を返すようにする
    matcher = "200"

    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-tg"
    }
  )
}
