resource "aws_acm_certificate" "main" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-certificate"
    }
  )

  # 証明書更新時に既存証明書を先に削除しない（downtimeを減らす）
  lifecycle {
    create_before_destroy = true
  }
}

# ACMが要求するDNS検証用CNAMEレコードをRoute 53へ登録する　
resource "aws_route53_record" "validation" {
  #複数ドメインを登録可能のため、サブドメインではない
  for_each = {
    #ACMが作成したドメイン検証用のCNAMEレコードをRoute53に登録する
    for option in aws_acm_certificate.main.domain_validation_options :
    option.domain_name => {
      name   = option.resource_record_name
      type   = option.resource_record_type
      record = option.resource_record_value
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  # 変更反映の速さ ↔ DNS問い合わせ効率のトレードオフ。
  ttl     = 300
  records = [each.value.record]
}

# DNS検証が完了するまで待機する＝証明書が使えるようになるまで待機することでエラーを防ぐ
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn

  validation_record_fqdns = [
    for record in aws_route53_record.validation : record.fqdn
  ]
}