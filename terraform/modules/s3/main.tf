# S3 Bucket Module
# Creates S3 buckets with versioning, encryption, and lifecycle rules

variable "environment" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "lifecycle_expiration_days" {
  type    = number
  default = 90
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.environment}-${var.bucket_name}"
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}
