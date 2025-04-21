# Default provider 
provider "aws" {
  region = var.aws_regions[0]
}

# Providers with account and region in the alias
provider "aws" {
  alias  = "delegated_account_us-west-2"
  region = var.aws_regions[0]
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "delegated_account_us-east-1"  
  region = var.aws_regions[1]
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "tfg-test-account1_us-west-2"  
  region = var.aws_regions[0]
  assume_role {
    role_arn = "arn:aws:iam::${var.tfg_test_account1_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "tfg-test-account1_us-east-1"  
  region = var.aws_regions[1]
  assume_role {
    role_arn = "arn:aws:iam::${var.tfg_test_account1_id}:role/OrganizationAccountAccessRole"
  }
}
