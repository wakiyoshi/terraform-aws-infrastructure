terraform {
  backend "s3" {
    bucket       = "grant-application-tfstate-463200133916-ap-northeast-1"
    key          = "dev/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
