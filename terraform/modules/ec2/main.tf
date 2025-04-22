resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.key_pair_filename)
}

resource "aws_instance" "example" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = var.instance_subnet_id

   key_name = aws_key_pair.deployer.key_name
  #security_groups =

  tags = {
    Name = "${var.instance_name}"
  }
}
