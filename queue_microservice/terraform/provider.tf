# Define cloud providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.15.1"
    }
  }
}

provider "aws" {
  profile = "default"

  default_tags {
    tags = {
      Serveless = "${var.resource_name}"
    }
  }
}
