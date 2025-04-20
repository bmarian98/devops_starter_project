resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-tfstate-12244"

  # Prevent accidental deletion of this bucket
  #   lifecycle {
  #     prevent_destroy = true
  #   }

  tags = {
    Name = "tfstate"
  }
}