# Define cloud providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.14.0"
    }
  }
}

provider "aws" {
  profile = "default"

  default_tags {
    tags = {
      Serveless = "SQS-Basic"
    }
  }
}