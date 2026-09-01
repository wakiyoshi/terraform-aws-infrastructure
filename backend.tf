// dev環境のtfstate保存先
terraform {
  backend "s3" {
    bucket       = "my-application-dev-tfstate-XXXXXXXXXXXXX-ap-northeast-1"
    key          = "dev/terraform.tfstate"
    region       = "ap-northeast-1"
    profile      = "dev-account"
    encrypt      = true
    use_lockfile = true
  }
}
