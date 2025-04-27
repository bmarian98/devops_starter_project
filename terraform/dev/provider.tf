terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-12244t"   # <-- your S3 bucket name
    key            = "DEV/terraform.tfstate"      # <-- path inside the bucket
    region         = "eu-central-1"                   # <-- your bucket's region
    dynamodb_table = "terraform-state-locks"      # <-- optional but recommended for state locking
    encrypt        = true                             # <-- encrypt the state file at rest
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
