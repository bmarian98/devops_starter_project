resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name        = "vpc-${var.vpc_name}"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.vpc.id
  count      = length(var.cidr_public_subnets)
  cidr_block = var.cidr_public_subnets[count.index]

  tags = {
    Name        = "${var.vpc_name}-public-subnet-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.vpc.id
  count      = length(var.cidr_private_subnets)
  cidr_block = var.cidr_private_subnets[count.index]

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    Environment = var.environment
  }
}


# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.igw_name}-igw"
  }
}

resource "aws_eip" "nat_public_ip" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"
}

# NAT gateway
resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gateway ? 1 : 0
  subnet_id     = aws_subnet.public_subnets[0].id
  allocation_id = aws_eip.nat_public_ip[0].id

  tags = {
    Name        = "${var.nat_gateway_name}-ngw"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.igw, aws_eip.nat_public_ip]
}

# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.route_table_name}-rt"
    Environment = var.environment
  }
}

# Route rules
resource "aws_route" "r" {
  route_table_id = aws_route_table.route_table.id

  # for_each = {
  #   for id, rule in var.route_rules : id => rule
  # }

  destination_cidr_block = var.default_cidr
  gateway_id             = aws_internet_gateway.igw.id
  nat_gateway_id         = var.enable_nat_gateway ? aws_nat_gateway.nat[0].id : null
  # transit_gateway_id     = lookup(each.value, "transit_gateway_id", null)
}

resource "aws_route_table_association" "assoc" {
  for_each       = { for id, subnet in aws_subnet.public_subnets : id => subnet }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.route_table.id
}

# Security groups
resource "aws_security_group" "sg" {
  name   = "${var.security_group_name}-sg"
  vpc_id = aws_vpc.vpc.id
}

# Security group rules
resource "aws_security_group_rule" "sg_rule" {
  for_each = {
    for id, rule in var.security_group_rules : "${id}" => rule
  }

  security_group_id = aws_security_group.sg.id
  type              = each.value.type
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_block
}
