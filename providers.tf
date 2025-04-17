# Default provider that uses OIDC credentials from Terraform Cloud
provider "aws" {
  region = var.aws_regions[0]

}

provider "aws" {
  alias  = "region1"
  region = var.aws_regions[0]
}

provider "aws" {
  alias  = "region2"
  region = var.aws_regions[1]
}

provider "aws" {
  alias  = "delegated_account"
  region = var.aws_regions[0]
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_account_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "delegated_account-region2"
  region = var.aws_regions[1]
  assume_role {
    role_arn = "arn:aws:iam::${var.delegated_account_id}:role/OrganizationAccountAccessRole"
  }
}


provider "aws" {
  alias  = "tfg-test-account1-region1"
  region = var.aws_regions[0]
  assume_role {
    role_arn = "arn:aws:iam::${var.tfg_test_account1_id}:role/OrganizationAccountAccessRole"
  }
}

provider "aws" {
  alias  = "tfg-test-account1-region2"
  region = var.aws_regions[1]
  assume_role {
    role_arn = "arn:aws:iam::${var.tfg_test_account1_id}:role/OrganizationAccountAccessRole"
  }
}

