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

# Add VPC outputs
output "vpc_ids" {
  description = "IDs of the created VPCs"
  value       = module.vpc.vpc_ids
}

output "vpc_cidrs" {
  description = "CIDR blocks of the created VPCs"
  value       = module.vpc.vpc_cidrs
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = module.vpc.subnet_ids
}

output "subnet_cidrs" {
  description = "CIDR blocks of the created subnets"
  value       = module.vpc.subnet_cidrs
}