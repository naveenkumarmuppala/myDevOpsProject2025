# s3 bucket for terraform state
resource "aws_s3_bucket" "tf_state" {
  bucket = "dsoapp-terraform-state-bucket-460474850843"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "dev"
    Project     = "vpc-alb-asg"
  }
}

# Enable versioning for state file safety
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "tf_state_public_access_block" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.tf_state_key.arn
    }
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_state_lock" {
  name         = "dsoapp-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.tf_state_key.arn
  }

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "dev"
    Project     = "vpc-alb-asg"
  }
}

# KMS key for encrypting state files
resource "aws_kms_key" "tf_state_key" {
  description             = "KMS key for encrypting Terraform state files"
  deletion_window_in_days = 10
  enable_key_rotation       = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Allow account root (required)
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::460474850843:root"
        }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "Terraform State KMS Key"
    Environment = "dev"
    Project     = "vpc-alb-asg"
  }
}

resource "aws_kms_alias" "tf_state_key_alias" {
  name          = "alias/tf-state-key"
  target_key_id = aws_kms_key.tf_state_key.id
}
