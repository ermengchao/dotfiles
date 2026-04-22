provider "aws" {
  region = var.region
}

data "aws_ami" "nixos" {
  owners      = ["427812963091"]
  most_recent = true

  filter {
    name   = "name"
    values = ["nixos/${var.nixos_version}*"]
  }

  filter {
    name   = "architecture"
    values = [var.arch]
  }
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.nixos.id
  instance_type = var.instance_type
  key_name      = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = {
    Name = var.name
  }
}
