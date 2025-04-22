module "networking" {
  source                       = "../modules/vpc"
  cidr_block                   = "10.0.0.0/16"
  vpc_name                     = "web"
  cidr_private_subnet          = "10.0.0.0/24"
  cidr_public_subnet           = "10.0.1.0/24"
  igw_name                     = "WEB"
  route_table_name             = "default"
  security_group_name          = "default"
  route_table_rule_cider_block = "10.0.1.0/24"
  rt_public_subnet             = "10.0.1.0/24"
}

module "ec2" {
  source = "../modules/ec2"
  key_name = "my-ssh-key"
  key_pair_filename = "~/.ssh/id_ed25519.pub"
  instance_name = "ec2-mod"
  instance_ami = "ami-0dac2efb38d54a859"
  instance_type = "t2.micro"
  instance_subnet_id = module.networking.public_subnet_id
}