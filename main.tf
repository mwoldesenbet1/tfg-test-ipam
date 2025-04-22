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
  source = "./modules/networking/vpc" 
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

# Add the OUs module
module "ous" {
 source        = "./modules/ous"
 root_ou_id    = var.root_ou_id
 # account_email = var.account_email
}

# Add the Transit Gateway module
module "tgw" {
  source = "./modules/networking/tgw"
  aws_regions = var.aws_regions
  delegated_account_id = var.delegated_account_id
  
  # Pass VPC IDs from the VPC module
  vpc_west_id = module.vpc.vpc_ids["us-west-2"]
  vpc_east_id = module.vpc.vpc_ids["us-east-1"]
  
  # Pass BOTH public and private subnet IDs for TGW attachments
  # Properly reference individual subnet elements
  vpc_west_subnet_ids = [
    module.vpc.subnet_ids["us-west-2"][0],  # Public subnet
    module.vpc.subnet_ids["us-west-2"][1]   # Private subnet
  ]
  
  vpc_east_subnet_ids = [
    module.vpc.subnet_ids["us-east-1"][0],  # Public subnet
    module.vpc.subnet_ids["us-east-1"][1]   # Private subnet
  ]
  
  # Pass VPC CIDRs for route table entries
  vpc_west_cidr = module.vpc.vpc_cidrs["us-west-2"]
  vpc_east_cidr = module.vpc.vpc_cidrs["us-east-1"]
  
  # Pass route table IDs for both public and private route tables
  vpc_west_route_table_ids = {
    public  = module.vpc.route_table_ids["us-west-2-public"]
    private = module.vpc.route_table_ids["us-west-2-private"]
  }
  
  vpc_east_route_table_ids = {
    public  = module.vpc.route_table_ids["us-east-1-public"]
    private = module.vpc.route_table_ids["us-east-1-private"]
  }
  
  providers = {
    aws.delegated_account_us-west-2 = aws.delegated_account_us-west-2
    aws.delegated_account_us-east-1 = aws.delegated_account_us-east-1
  }
  
  depends_on = [module.vpc]
}
