resource "aws_cloudfront_function" "spa_rewrite" {
  name    = "${var.project_name}-${var.environment}-spa-rewrite"
  runtime = "cloudfront-js-2.0"
  comment = "Authenticate viewer requests and rewrite SPA screen paths"
  publish = true
  code = templatefile("${path.module}/spa-rewrite.js", {
    auth_hash = jsonencode(var.cloudfront_basic_auth == null ? "" : sha256("Basic ${base64encode("${var.cloudfront_basic_auth.username}:${var.cloudfront_basic_auth.password}")}"))
  })
}
