# Key pair
variable "key_name" {
  default = "ssh-key"
  type = string
}

variable "key_pair_filename" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

# EC2
variable "instance_name" {
  type = string
  default = "module-ec2"
}

variable "instance_ami" {
  type = string
  default = "ami-0dac2efb38d54a859"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_subnet_id" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
  default = true
}