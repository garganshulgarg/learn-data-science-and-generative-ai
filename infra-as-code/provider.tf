terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }
  backend "s3" {
    encrypt = true
    bucket         = "terraform-state-anshul"
    key            = "learn-data-science-and-generative-ai/dev/terraform.tfstate"
    region         = "us-east-1"
  }
}

# The default AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.required_tags
  }
}