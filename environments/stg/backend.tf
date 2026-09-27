terraform {
  backend "s3" {
    bucket       = "grant-application-stg-terraform-state-721563685066-ap-northeast-1"
    key          = "stg/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
