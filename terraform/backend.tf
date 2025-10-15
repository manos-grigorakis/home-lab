terraform {
  backend "s3" {
    bucket         = "amzn-s3-homelab-terraform-bucket"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "dynamodb-state-locking-terraform"
  }
}