locals {
  servers = toset([
    "application",
    "web",
    "access_management",
    "app_database",
    "iam_database",
    "object_storage",
    "message_broker"
  ])
}

resource "aws_key_pair" "ec2_ssh" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg"

  tags = {
    Name = "ec2_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "same_sg_rule" {
  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  ip_protocol                  = -1
  # from_port                    = 0
  # to_port                      = 65535
}

resource "aws_vpc_security_group_ingress_rule" "my_ip_rule" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "${var.my_public_ip}/32"
  ip_protocol       = "tcp"
  from_port         = 0
  to_port           = 65535
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
}

resource "aws_instance" "ec2_instance" {
  for_each = local.servers

  ami                    = "ami-04df1508c6be5879e"
  instance_type          = var.instance_type[each.key]
  key_name               = aws_key_pair.ec2_ssh.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  ebs_block_device {
    device_name = "/dev/sda1"
    iops        = 3000
    volume_type = "gp3"
    volume_size = var.volume_size[each.key]
  }

  tags = {
    Name = "i_${each.value}"
  }
}