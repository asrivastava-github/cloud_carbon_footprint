terraform {
  required_version = "1.2.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }
  }

  backend "s3" {
    region         = "eu-west-1"
    profile        = "carbon-footprint-aabg"
    bucket         = "cloudcarbonfootprint-tfstate-t1"
    key            = "ccf-aabg"
    encrypt        = true
    dynamodb_table = "aabg-terraform-lock"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "carbon-footprint-aabg"
}
