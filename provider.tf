# provider.tf (Root Directory)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0" # Updated to a more recent version
    }
  }
}

provider "aws" {
  region = var.aws_region
}