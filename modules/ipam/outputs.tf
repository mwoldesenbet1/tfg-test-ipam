output "ipam_id" {
  description = "ID of the created IPAM"
  value       = aws_vpc_ipam.main_ipam.id
}

output "private_scope_id" {
  description = "ID of the private IPAM scope"
  value       = aws_vpc_ipam_scope.private_scope.id
}

output "regional_pool_ids" {
  description = "IDs of regional pools"
  value       = { for k, v in aws_vpc_ipam_pool.regional_pools : k => v.id }
}

output "environment_pool_ids" {
  description = "IDs of environment pools"
  value       = { for k, v in aws_vpc_ipam_pool.environment_pools : k => v.id }
}

output "subnet_pool_ids" {
  description = "IDs of subnet pools"
  value       = { for k, v in aws_vpc_ipam_pool.subnet_pools : k => v.id }
}
