# VPC
variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "custom-vpc"
}

# Public subnet
variable "cidr_public_subnet" {
  type    = string
  default = "10.0.0.0/17"
}

# Private subnet
variable "cidr_private_subnet" {
  type    = string
  default = "10.0.128.0/17"
}

# IGW
variable "igw_name" {
  type    = string
  default = "custom"
}

# Route table
variable "route_table_name" {
  type    = string
  default = "default"
}

# Security group
variable "security_group_name" {
  type    = string
  default = "custom"
}

variable "route_table_rule_cider_block" {
  type    = string
  default = "10.0.0.0/17"
}

variable "rt_public_subnet" {
  type = string
}