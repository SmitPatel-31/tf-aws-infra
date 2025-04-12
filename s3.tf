resource "random_uuid" "s3_bucket_uuid" {}

resource "aws_s3_bucket" "private_bucket" {
  bucket        = uuid() # Creates a unique bucket name
  force_destroy = true
  tags = {
    Name = "private-s3-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "private_bucket_ownership" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "default_encryption" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = data.aws_kms_key.s3_key.arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_policy" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    id     = "standard-to-standard-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
