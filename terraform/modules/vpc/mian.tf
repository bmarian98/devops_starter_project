resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_public_subnet

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_private_subnet

  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}


# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.igw_name}-igw"
  }
}


# Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.route_table_name}-rt"
  }
}


# Route rules
# resource "aws_route" "r" {
#   route_table_id         = aws_route_table.route_table.id
#   destination_cidr_block = var.route_table_rule_cider_block
#   gateway_id             = aws_internet_gateway.igw.id
# }

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}


# Security groups
resource "aws_security_group" "sg" {
  name   = "${var.security_group_name}-sg"
  vpc_id = aws_vpc.vpc.id
}

# Security group rules
resource "aws_vpc_security_group_ingress_rule" "allow" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = aws_vpc.vpc.cidr_block # To  be replaced
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}