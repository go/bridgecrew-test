data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bridgecrew-demo" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.bridgecrew-demo.id}"]
  subnet_id              = aws_subnet.bridgecrew-demo.1.id
  key_name               = var.key_name
  monitoring             = true

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${var.instance_name}"
  }
}
