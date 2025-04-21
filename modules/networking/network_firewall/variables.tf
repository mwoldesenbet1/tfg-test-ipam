variable "aws_regions" {
  type        = list(string)
  description = "List of AWS regions for Network Firewall deployment"
  default     = ["us-west-2", "us-east-1"]
}

variable "vpc_ids" {
  description = "Map of VPC IDs by region"
  type        = map(string)
}

variable "firewall_subnet_ids" {
  description = "Map of subnet IDs by region for firewall deployment"
  type        = map(list(string))
}
