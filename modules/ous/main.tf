# Create TFG-Sandbox_OU
resource "aws_organizations_organizational_unit" "tfg-sandbox_ou" {
  name      = "TFG Sandbox OU"
  parent_id = var.root_ou_id
}

# Create TFG-Development_OU
resource "aws_organizations_organizational_unit" "tfg-dev_ou" {
  name      = "TFG Dev OU"
  parent_id = var.root_ou_id
}

# Create TFG-Prod_OU
resource "aws_organizations_organizational_unit" "tfg-prod_ou" {
  name      = "TFG Prod OU"
  parent_id = var.root_ou_id
}


# Create tfg-sandbox-account1
#resource "aws_organizations_account" "tfg-test-account1" {
 # name      = "TFG-Test-Account 1" 
 # email     = var.account_email
  #parent_id = aws_organizations_organizational_unit.tfg-sandbox_ou.id
  #role_name = "OrganizationAccountAccessRole"
#}

# Add a wait time to ensure account creation completes
#resource "time_sleep" "wait_for_account_ready" {
# depends_on = [aws_organizations_account.tfg-test-account1]
# create_duration = "120s"
#}
