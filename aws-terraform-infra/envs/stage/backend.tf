terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "dsoapp-terraform-state-bucket-460474850843"
    key            = "stage/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dsoapp-terraform-state-lock"
    encrypt        = true
    kms_key_id     = "alias/tf-state-key"
  }
}
