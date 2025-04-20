module "networking" {
  source                       = "../modules/vpc"
  cidr_block                   = "10.0.0.0/16"
  vpc_name                     = "web"
  cidr_private_subnet          = "10.0.0.0/24"
  cidr_public_subnet           = "10.0.1.0/24"
  igw_name                     = "WEB"
  route_table_name             = "default"
  security_group_name          = "default"
  route_table_rule_cider_block = "ssh"

}