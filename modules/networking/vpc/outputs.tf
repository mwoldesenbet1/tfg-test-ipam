output "vpc_ids" {
  description = "IDs of the created VPCs"
  value = {
    "${var.aws_regions[0]}" = aws_vpc.vpc_west.id
    "${var.aws_regions[1]}" = aws_vpc.vpc_east.id
  }
}

output "vpc_cidrs" {
  description = "CIDR blocks of the created VPCs"
  value = {
    "${var.aws_regions[0]}" = aws_vpc.vpc_west.cidr_block
    "${var.aws_regions[1]}" = aws_vpc.vpc_east.cidr_block
  }
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value = {
    "${var.aws_regions[0]}" = aws_subnet.subnet_west[*].id
    "${var.aws_regions[1]}" = aws_subnet.subnet_east[*].id
  }
}

output "subnet_cidrs" {
  description = "CIDR blocks of the created subnets"
  value = {
    "${var.aws_regions[0]}" = aws_subnet.subnet_west[*].cidr_block
    "${var.aws_regions[1]}" = aws_subnet.subnet_east[*].cidr_block
  }
}

