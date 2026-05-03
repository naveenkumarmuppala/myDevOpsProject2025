terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "dsoapp-terraform-state-prod-bucket-460474850843"
    key            = "prod/vpc-alb-asg/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dsoapp-terraform-state-lock"
    encrypt        = true
    kms_key_id     = "alias/tf-state-key"
  }
}
