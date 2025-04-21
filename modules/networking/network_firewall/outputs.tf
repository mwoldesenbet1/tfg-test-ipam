output "firewall_ids" {
  description = "IDs of the created Network Firewalls"
  value = {
    "${var.aws_regions[0]}" = aws_networkfirewall_firewall.firewall_west.id
    "${var.aws_regions[1]}" = aws_networkfirewall_firewall.firewall_east.id
  }
}

output "firewall_arns" {
  description = "ARNs of the created Network Firewalls"
  value = {
    "${var.aws_regions[0]}" = aws_networkfirewall_firewall.firewall_west.arn
    "${var.aws_regions[1]}" = aws_networkfirewall_firewall.firewall_east.arn
  }
}

output "firewall_policy_arn" {
  description = "ARN of the Network Firewall policy"
  value       = aws_networkfirewall_firewall_policy.main.arn
}

output "firewall_endpoints" {
  description = "Firewall endpoints by availability zone"
  value = {
    "${var.aws_regions[0]}" = aws_networkfirewall_firewall.firewall_west.firewall_status[0].sync_states[*].attachment[0].endpoint_id
    "${var.aws_regions[1]}" = aws_networkfirewall_firewall.firewall_east.firewall_status[0].sync_states[*].attachment[0].endpoint_id
  }
}
