terraform {
  backend "s3" {
    bucket = "terraform-tfstate-12244t"
    key    = "DEV/terraform.tfstate"
    region = "eu-central-1"
    #dynamodb_table = "terraform-state-locks"      # deprecated replace with use_locking (no need dynamo db)
    use_lockfile = true
    encrypt      = true
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
