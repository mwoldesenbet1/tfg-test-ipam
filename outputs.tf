output "ipam_id" {
  description = "ID of the created IPAM"
  value       = module.ipam.ipam_id
}

output "private_scope_id" {
  description = "ID of the private IPAM scope"
  value       = module.ipam.private_scope_id
}

output "regional_pool_ids" {
  description = "IDs of regional pools"
  value       = module.ipam.regional_pool_ids
}

output "environment_pool_ids" {
  description = "IDs of environment pools"
  value       = module.ipam.environment_pool_ids
}

output "subnet_pool_ids" {
  description = "IDs of subnet pools"
  value       = module.ipam.subnet_pool_ids
}
