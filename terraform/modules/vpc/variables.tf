# ENV
variable "environment" {
  type    = string
  default = "DEV"
}

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
variable "cidr_public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/17"]
}

# Private subnet
variable "cidr_private_subnets" {
  type    = list(string)
  default = ["10.0.128.0/17"]
}

# IGW
variable "igw_name" {
  type    = string
  default = "custom"
}

# NAT gateway
variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "nat_gateway_name" {
  type    = string
  default = "default"
}

# Route table
variable "route_table_name" {
  type    = string
  default = "default"
}

# variable "route_rules" {
#   type = list(object({
#     destination_cidr_block = string
#     gateway_id             = optional(string)
#     nat_gateway_id         = optional(string)
#     transit_gateway_id     = optional(string)
#   }))
# }

# Security group
variable "security_group_name" {
  type    = string
  default = "custom"
}

variable "security_group_rules" {
  type = list(object({
    type        = string
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = list(string)
  }))

  default = [{
    type        = "ingress"
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = ["0.0.0.0/0"]
    },
    {
      type        = "egress"
      description = "Allow all egress"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      cidr_block  = ["0.0.0.0/0"]
  }]
}


variable "default_cidr" {
  default = "0.0.0.0/0"
  type    = string
}