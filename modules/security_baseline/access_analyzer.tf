resource "aws_accessanalyzer_analyzer" "main" {

  analyzer_name = "${var.project_name}-${var.environment}-external-access"
  type          = "ACCOUNT"
  tags          = var.common_tags
}
