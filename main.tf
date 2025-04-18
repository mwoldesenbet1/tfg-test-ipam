terraform {
  backend "remote" {
     organization = "TFG-IPAM"
       workspaces {
       name = "tfg-test-ipam"
     }
    }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}



# Add the IPAM module

module "ipam" {
  source = "./modules/ipam"
  aws_regions = var.aws_regions
  delegated_account_id = var.delegated_account_id
  providers = {
    aws.region1 = aws.delegated_account
    #aws.region2 = aws.delegated_account-region2
  }
}
