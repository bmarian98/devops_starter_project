output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnets[*].id
}

output "security_group_id" {
  value = aws_security_group.sg.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gw_id" {
  value = var.enable_nat_gateway ? aws_nat_gateway.nat[0].id : null
}