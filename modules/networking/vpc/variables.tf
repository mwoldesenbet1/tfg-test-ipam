variable "aws_regions" {
  type        = list(string)
  description = "List of AWS regions for VPC creation"
  default     = ["us-west-2", "us-east-1"]
}

variable "vpc_names" {
  description = "Names for the VPCs in each region"
  type        = map(string)
  default = {
    "us-west-2" = "production-vpc"
    "us-east-1" = "nonproduction-vpc"
  }
}

variable "subnet_names" {
  description = "Names for the subnets in each VPC"
  type        = map(list(string))
  default = {
    "us-west-2" = ["prod-subnet-1", "prod-subnet-2"]
    "us-east-1" = ["nonprod-subnet-1", "nonprod-subnet-2"]
  }
}

variable "ipam_pool_ids" {
  description = "IDs of IPAM pools to use for each VPC"
  type        = map(string)
}