module "s3_tfstate" {
  source = "../s3"
}


resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = module.s3_tfstate.bucket_id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Optional: Add tags
  tags = {
    Name = "Terraform State Lock Table"
  }
}