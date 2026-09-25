resource "aws_ecr_repository" "main" {
  # 既存PROD名は維持し、同一AWSアカウント内でもDEV/STGと衝突させない
  name = var.environment == "prod" ? "${var.project_name}-app" : "${var.project_name}-${var.environment}-app"

  # 同じタグによるイメージの上書きを禁止する
  image_tag_mutability = "IMMUTABLE"

  # Inspector による push 時の拡張スキャンは security/baseline で
  # レジストリ単位に設定する。

  # ECRに保存するイメージを暗号化する、KMSの選択肢もある
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    var.common_tags,
    {
      Name        = var.environment == "prod" ? "${var.project_name}-app" : "${var.project_name}-${var.environment}-app"
      Environment = var.environment
    }
  )
}
