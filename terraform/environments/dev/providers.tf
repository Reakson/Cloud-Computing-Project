terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Stage 1: leave this local for your very first `terraform apply`, just to
  # confirm everything works. Once that succeeds, switch to the S3 backend
  # block below (uncomment it, create the bucket + DynamoDB table first)
  # so the whole team shares one state file instead of everyone's laptop
  # having its own.
  #
  backend "s3" {
  bucket         = "keypkey-terraform-state"
  key            = "dev/terraform.tfstate"
  region         = "ap-southeast-1"
  dynamodb_table = "keypkey-terraform-locks"
  encrypt        = true
}
}

provider "aws" {
  region = var.aws_region
}
