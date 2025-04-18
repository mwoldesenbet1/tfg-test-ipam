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
  share_with_account_id = var.tfg_test_account1_id
  providers = {
    aws.delegated_account_us-west-2 = aws.delegated_account_us-west-2
    aws.delegated_account_us-east-1 = aws.delegated_account_us-east-1
  }
}

# Add the VPC module
module "vpc" {
  source = "./modules/vpc"
  aws_regions = var.aws_regions
  
  # Map IPAM pool IDs to use for VPC CIDRs
  ipam_pool_ids = {
    "us-west-2-prod" = module.ipam.environment_pool_ids["us-west-2-prod"]
    "us-east-1-nonprod" = module.ipam.environment_pool_ids["us-east-1-nonprod"]
  }
  
  providers = {
    aws.delegated_account_us-west-2 = aws.delegated_account_us-west-2
    aws.delegated_account_us-east-1 = aws.delegated_account_us-east-1
  }
  
  depends_on = [module.ipam]
}