# HTTPリクエストはHTTPSへのリダイレクトにのみ使用する
resource "aws_lb_listener" "http" {
  // 同じモジュール内なのでalb.tfで定義したaws_lb.mainのARNを参照できる,outputsは必要ない
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.certificate_arn != null ? [1] : []

    content {
      type = "redirect"

      redirect {
        port     = "443"
        protocol = "HTTPS"
        //301 Moved Permanently（恒久的リダイレクト）
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = var.certificate_arn == null ? [1] : []

    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.main.arn
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-http-listener"
    }
  )
}

# ALBでTLSを終端し、アプリケーションのTarget Groupへ転送する
resource "aws_lb_listener" "https" {
  count = var.certificate_arn != null ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  // TLS接続のルールを決める
  ssl_policy = var.ssl_policy

  default_action {
    // forwardは、リクエストをターゲットグループに転送する
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-https-listener"
    }
  )
}
