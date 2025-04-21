# AWS Network Firewall module
# Implements a distributed deployment model for AWS Network Firewall

# Create the Network Firewall Policy
resource "aws_networkfirewall_firewall_policy" "main" {
  provider = aws.delegated_account_us-west-2
  name     = "main-network-firewall-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    
    # Adding stateful rule groups
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.block_domains.arn
    }
    
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.block_ports.arn
    }
  }

  tags = {
    Name        = "main-network-firewall-policy"
    Environment = "shared"
    ManagedBy   = "terraform"
  }
}

# Create a domain blocking rule group
resource "aws_networkfirewall_rule_group" "block_domains" {
  provider    = aws.delegated_account_us-west-2
  capacity    = 100
  name        = "blocked-domains"
  type        = "STATEFUL"
  description = "Blocks access to specified domains"

  rule_group {
    rules_source {
      rules_source_list {
        generated_rules_type = "DENYLIST"
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        targets              = [".example.malicious.com", ".test.unwanted.com"]
      }
    }
  }

  tags = {
    Name = "blocked-domains"
  }
}

# Create a port blocking rule group
resource "aws_networkfirewall_rule_group" "block_ports" {
  provider    = aws.delegated_account_us-west-2
  capacity    = 100
  name        = "blocked-ports"
  type        = "STATEFUL"
  description = "Blocks traffic on specified ports"

  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          protocol         = "TCP"
          direction        = "ANY"
          source_port      = "ANY"
          source           = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }
    }
  }

  tags = {
    Name = "blocked-ports"
  }
}

# Create firewall in us-west-2 (Production)
resource "aws_networkfirewall_firewall" "firewall_west" {
  provider = aws.delegated_account_us-west-2
  name     = "production-firewall"
  
  firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
  vpc_id              = var.vpc_ids["us-west-2"]
  
  # Create firewall in dedicated subnets across AZs
  dynamic "subnet_mapping" {
    for_each = var.firewall_subnet_ids["us-west-2"]
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name        = "production-firewall"
    Environment = "Production"
    ManagedBy   = "terraform"
  }
}

# Create firewall in us-east-1 (Non-Production)
resource "aws_networkfirewall_firewall" "firewall_east" {
  provider = aws.delegated_account_us-east-1
  name     = "nonproduction-firewall"
  
  firewall_policy_arn = aws_networkfirewall_firewall_policy.main.arn
  vpc_id              = var.vpc_ids["us-east-1"]
  
  # Create firewall in dedicated subnets across AZs
  dynamic "subnet_mapping" {
    for_each = var.firewall_subnet_ids["us-east-1"]
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = {
    Name        = "nonproduction-firewall"
    Environment = "NonProduction"
    ManagedBy   = "terraform"
  }
}
