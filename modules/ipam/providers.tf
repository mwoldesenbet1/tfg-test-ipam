# In modules/ipam/providers.tf
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.region1,
        aws.region2
      ]
    }
  }
}
# This empty provider block tells Terraform that this module 
# can receive provider configuration from the parent module
#provider "aws" {
#}
