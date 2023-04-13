data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_vpc" "default" {
  default = true
}
resource "aws_instance" "blog" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = "t3.nano"
  vpc_security_group_ids = [aws_security_group.blog.id]
  tags                   = {
    Name = "Learning platform"
  }
}

resource "aws_security_group" "blog" {
  name        = "blog"
  description = "Allow http and Https in Allow anything in"

  vpc_id = aws_vpc.default.id
}

resource "aws_security_group_rule" "blog_http_in" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.blog.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "blog_https_in" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.blog.id
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
