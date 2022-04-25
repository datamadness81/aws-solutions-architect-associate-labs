#----------------------------------------------------
#                   PROVIDERS
#----------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.10.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region

  default_tags {
    tags = {
      Skills = "Serveless"
    }
  }
}