# --------------------------
# Create a single AWS IPAM
# --------------------------
resource "aws_vpc_ipam" "main_ipam" {
  provider    = aws.delegated_account-region2
  description = "Global IPAM for managing CIDR blocks"

  dynamic "operating_regions" {
    for_each = toset(var.aws_regions)
    content {
      region_name = operating_regions.value
    }
  }
}

# --------------------------
# Create Top-Level IPAM Scope
# --------------------------
resource "aws_vpc_ipam_scope" "private_scope" {
  provider    = aws.delegated_account-region2
  ipam_id     = aws_vpc_ipam.main_ipam.id
  description = "Private IPAM Scope"
}

# --------------------------
# Create Top-Level IPAM Pools for each Region
# --------------------------
resource "aws_vpc_ipam_pool" "regional_pools" {
  for_each = toset(var.aws_regions)
  
  ipam_scope_id  = aws_vpc_ipam_scope.private_scope.id
  locale         = each.key
  address_family = "ipv4"
  description    = "Top-Level ${each.key} /16 Pool"
}

resource "aws_vpc_ipam_pool_cidr" "regional_cidrs" {
  for_each = toset(var.aws_regions)
  
  ipam_pool_id = aws_vpc_ipam_pool.regional_pools[each.key].id
  cidr         = var.region_cidrs[each.key]
}

# --------------------------
# Create Environment Pools (Prod/Non-Prod) for each Region
# --------------------------
resource "aws_vpc_ipam_pool" "environment_pools" {
  for_each = {
    for pair in setproduct(var.aws_regions, keys(var.environments)) : 
    "${pair[0]}-${pair[1]}" => {
      region = pair[0]
      env    = pair[1]
    }
  }
  
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = each.value.region
  address_family      = "ipv4"
  description         = "${each.value.region} ${var.environments[each.value.env].description} Pool"
  source_ipam_pool_id = aws_vpc_ipam_pool.regional_pools[each.value.region].id
}

resource "aws_vpc_ipam_pool_cidr" "environment_cidrs" {
  for_each = {
    for pair in setproduct(var.aws_regions, keys(var.environments)) : 
    "${pair[0]}-${pair[1]}" => {
      region = pair[0]
      env    = pair[1]
    }
  }
  
  ipam_pool_id = aws_vpc_ipam_pool.environment_pools["${each.value.region}-${each.value.env}"].id
  cidr         = replace(var.region_cidrs[each.value.region], "0.0/16", var.environments[each.value.env].cidr_suffix)
  depends_on   = [aws_vpc_ipam_pool_cidr.regional_cidrs]
}

# --------------------------
# Create Subnet Pools for each Environment in each Region
# --------------------------
resource "aws_vpc_ipam_pool" "subnet_pools" {
  for_each = {
    for triplet in flatten([
      for region in var.aws_regions : [
        for env_name, env in var.environments : [
          for subnet_num in range(1, env.subnets + 1) : {
            key     = "${region}-${env_name}-subnet${subnet_num}"
            region  = region
            env     = env_name
            env_obj = env
            num     = subnet_num
          }
        ]
      ]
    ]) : triplet.key => triplet
  }
  
  ipam_scope_id       = aws_vpc_ipam_scope.private_scope.id
  locale              = each.value.region
  address_family      = "ipv4"
  description         = "${each.value.region} ${var.environments[each.value.env].description} Subnet ${each.value.num}"
  source_ipam_pool_id = aws_vpc_ipam_pool.environment_pools["${each.value.region}-${each.value.env}"].id
}

resource "aws_vpc_ipam_pool_cidr" "subnet_cidrs" {
  for_each = {
    for triplet in flatten([
      for region in var.aws_regions : [
        for env_name, env in var.environments : [
          for subnet_num in range(1, env.subnets + 1) : {
            key     = "${region}-${env_name}-subnet${subnet_num}"
            region  = region
            env     = env_name
            env_obj = env
            num     = subnet_num
          }
        ]
      ]
    ]) : triplet.key => triplet
  }
  
  ipam_pool_id   = aws_vpc_ipam_pool.subnet_pools[each.key].id
  netmask_length = 21
  depends_on     = [aws_vpc_ipam_pool_cidr.environment_cidrs]
}
