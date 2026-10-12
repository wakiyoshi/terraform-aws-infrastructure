
// 委任設定
resource "aws_route53_record" "environment_delegation" {
  for_each = var.delegated_name_servers

  zone_id = module.main.route53_zone_id
  name    = "${each.key}.${var.domain_name}"
  type    = "NS"
  ttl     = 300
  records = each.value
}
