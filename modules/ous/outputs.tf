output "sandbox_ou_id" {
  description = "ID of the created Sandbox OU"
  value       = aws_organizations_organizational_unit.tfg-sandbox_ou.id
}


output "dev_ou_id" {
  description = "ID of the created Sandbox OU"
  value       = aws_organizations_organizational_unit.tfg-dev_ou.id
}

output "prod_ou_id" {
  description = "ID of the created Sandbox OU"
  value       = aws_organizations_organizational_unit.tfg-prod_ou.id
}



#output "tfg_test_account1_id" {
 # description = "ID of the created test account"
  #value       = aws_organizations_account.tfg-test-account1.id
#}
