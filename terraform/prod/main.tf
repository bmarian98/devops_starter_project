variable "enable_nat_gateway" {
  type    = bool
  default = false
}

locals {
  resources_id = var.enable_nat_gateway ? {
    nat_gateway_id     = module.networking.nat_gwy_id
    gateway_id         = module.networking.igw_id
    transit_gateway_id = null
    } : {
    gateway_id = module.networking.igw_id
  }
}

module "networking" {
  source               = "../modules/vpc"
  environment          = "PROD"
  cidr_block           = "10.0.0.0/16"
  vpc_name             = "web"
  cidr_private_subnets = ["10.0.0.0/24"]
  cidr_public_subnets  = ["10.0.1.0/24"]
  igw_name             = "WEB"
  route_table_name     = "default"
  security_group_name  = "default"
  enable_nat_gateway   = false
  security_group_rules = [{
    type        = "ingress"
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_block  = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      description = "Allow ping"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      cidr_block  = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      description = "Allow http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      description = "Allow port for Prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      description = "Allow port for Grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    },
    {
      type        = "egress"
      description = "Allow all output traffic"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      cidr_block  = ["0.0.0.0/0"]
  }]
  # route_rules = [{
  #   destination_cidr_block = "0.0.0.0/0"
  #   gateway_id             = local.resources_id.gateway_id
  # }]
}

module "ec2" {
  source                      = "../modules/ec2"
  environment                 = "PROD"
  key_name                    = "my-ssh-key"
  key_pair_filename           = "~/.ssh/id_ed25519.pub"
  instance_name               = "ec2-mod"
  instance_ami                = "ami-0d8d11821a1c1678b"
  instance_type               = "t2.micro"
  instance_subnet_id          = module.networking.public_subnet_id[0]
  security_group_id           = module.networking.security_group_id
  associate_public_ip_address = true
}

resource "local_file" "inventory_file" {
  filename = "../../ansible//inventory.ini"

  content = templatefile("../../ansible//inventory.tpl", {
    public_ip = module.ec2.public_ip_address
  })
}
