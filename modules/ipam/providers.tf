terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# This empty provider block tells Terraform that this module 
# can receive provider configuration from the parent module
provider "aws" {
}
