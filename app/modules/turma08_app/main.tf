resource "aws_key_pair" "app-ssh-key" {
  key_name   = format("%s-app-key", local.name)
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDW1T7Zr/rbCG9SO+dWFRWHlclA9LDYZQyvQdg94HHxEANXU0PMztksXbuP977AgBWJL95g5CV8xLiW7PjmKD0YVCFU16I8GZ7vDo7ZygWfvpXo2ioII0X8kkfAfZHKksdR2n13U/nxRbQt6AWSPvLqoLybSsI4aqD6b826D2EDyj7ogCGL6Ct6SyvFelc6B5ZH51ol5oY+nO1+qN3oDqovNdh7HNfsSbXdKl1xMzebkmvX5Lq5CyE8lAuXarJTmYcc9/CYYmVfDFMe+/DIHvaZ+DLF/4bB/5mnsYFvAcCf/7NBkxzYC2fglSTFaYKams7P0MfSUrs2jkvsuVk38CKPwV4bDBLjlS40/AxBcugzNsmCXYvUnKDgINHvI5t4JOxMFMNUZYvFa6BqaKMtfS08tmrfPz4/FdJ+5HWoB5MMttUBAMY8H/5ppkynUvuXUTMYzJ2eZ93m+v0M0quV/6/7SSONtx/kTZ+dj5K4ebXAm3J/bj1wT1TUvkdlft1EBM8= app-turma08"
}

resource "aws_instance" "app-ec2" {
  count                       = lookup(var.instance_count, var.env)
  ami                         = data.aws_ami.amazon-lnx.id
  instance_type               = lookup(var.instance_type_app, var.env)
  subnet_id                   = data.aws_subnet.app-public-subnet.id
  associate_public_ip_address = true
  tags = {
    Name = format("%s-app", local.name)
  }
  key_name  = aws_key_pair.app-ssh-key.id
  user_data = data.template_file.ec2-app.rendered
}

resource "aws_instance" "app-mongdb" {
  ami           = data.aws_ami.amazon-lnx.id
  instance_type = var.instance_type_mongodb
  subnet_id     = data.aws_subnet.app-public-subnet.id
  associate_public_ip_address = false
  tags = {
    Name = format("%s-mongodb", local.name)
  }
  key_name  = aws_key_pair.app-ssh-key.id
  user_data = data.template_file.ec2-mongodb.rendered
}

resource "aws_security_group" "allow-http-ssh" {
  name        = format("%s-allow-http-ssh", local.name)
  description = "Allow http and ssh ports"
  vpc_id      = data.aws_vpc.vpc.id

  ingress = [
    {
      description      = "Allow ssh"
      from_port        = "22"
      to_port          = "22"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    },
    {
      description      = "Allow ssh"
      from_port        = "80"
      to_port          = "80"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }
  ]

  egress = [
    {
      description      = "Allow all"
      from_port        = "0"
      to_port          = "0"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    },
    {
      description      = "Allow ssh"
      from_port        = "80"
      to_port          = "80"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }
  ]
}

resource "aws_security_group" "allow-mongodb" {
  name        = format("%s-allow-mongodb", local.name)
  description = "Allow mongodb ports"
  vpc_id      = data.aws_vpc.vpc.id

  ingress = [
    {
      description      = "Allow mongodb"
      from_port        = "27017"
      to_port          = "27017"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }
  ]

  egress = [
    {
      description      = "Allow all"
      from_port        = "0"
      to_port          = "0"
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = null
    }
  ]
}

resource "aws_network_interface_sg_attachment" "app-sg" {
  count                       = lookup(var.instance_count, var.env)
  security_group_id    = aws_security_group.allow-http-ssh.id
  network_interface_id = aws_instance.app-ec2[count.index].primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "mongodb-sg" {
  security_group_id    = aws_security_group.allow-mongodb.id
  network_interface_id = aws_instance.app-mongdb.primary_network_interface_id
}

resource "aws_route53_zone" "app-zone" {
  name = format("%s.com.br", var.project)
  count = var.env == "prod" ? 1 : var.create_zone_dns == false ? 0 : 1
  vpc {
    vpc_id = data.aws_vpc.vpc.id
  }
}

resource "aws_route53_record" "mongodb" {
  count   = var.env == "prod" ? 1 : var.create_zone_dns == false ? 0 : 1
  zone_id = aws_route53_zone.app-zone[count.index].id
  name    = format("mongodb.%s.com.br", var.project)
  type    = "A"
  ttl     = "300"
  records = [aws_instance.app-mongdb.private_ip]
}