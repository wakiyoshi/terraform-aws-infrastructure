resource "aws_acm_certificate" "main" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

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
  # Apexとワイルドカードは同じ検証レコードを使用するため、Apexの1件だけを登録する。
  for_each = var.create_validation_records ? toset([var.domain_name]) : toset([])

  zone_id = var.route53_zone_id
  name = one([
    for option in aws_acm_certificate.main.domain_validation_options : option.resource_record_name
    if option.domain_name == each.value
  ])
  type = one([
    for option in aws_acm_certificate.main.domain_validation_options : option.resource_record_type
    if option.domain_name == each.value
  ])
  # 変更反映の速さ ↔ DNS問い合わせ効率のトレードオフ。
  ttl = 300
  records = [one([
    for option in aws_acm_certificate.main.domain_validation_options : option.resource_record_value
    if option.domain_name == each.value
  ])]
}

# DNS検証が完了するまで待機する＝証明書が使えるようになるまで待機することでエラーを防ぐ
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn

  validation_record_fqdns = concat(var.validation_record_fqdns, [
    for record in aws_route53_record.validation : record.fqdn
  ])
}
