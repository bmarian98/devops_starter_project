resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.key_pair_filename)
}

resource "aws_instance" "ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = var.instance_subnet_id

   key_name = aws_key_pair.deployer.key_name
   associate_public_ip_address = var.associate_public_ip_address
  #security_groups =

  tags = {
    Name = "${var.instance_name}"
  }
}
