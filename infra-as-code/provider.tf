terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
}

# The default AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.required_tags
  }
}