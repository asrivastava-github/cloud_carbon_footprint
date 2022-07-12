resource "aws_security_group" "web_ccf_instance_sg" {
  name   = "web-ccf-instance-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "app_ccf_instance_sg" {
  name   = "app-ccf-instance-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_ccf_instance_sg.id]
  }
  
  
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_ccf_instance_sg.id]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
}

resource "aws_iam_instance_profile" "ccf_instance_profile" {
  name = "ccf-instance-profile"
  role = aws_iam_role.ccf_api_role.name
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  ami                    = var.app_ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.app_ccf_instance_sg.id]
  subnet_id              = var.target_subnet_id
  user_data              = file("${path.module}/src/install-ccf.sh")
  iam_instance_profile   = aws_iam_instance_profile.ccf_instance_profile.name

  tags = var.tags
}

module "ec2_instance_web" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  ami                    = var.web_ami_id
  get_password_data      = true
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.web_ccf_instance_sg.id]
  subnet_id              = var.target_subnet_id

  tags = var.tags

  depends_on = [
    module.ec2_instance
  ]
}

output "web_password" {
  value = module.ec2_instance_web.password_data
}


# resource "aws_route53_record" "ccf-internal" {
#   name    = var.dns_name
#   records = [aws_eip.ccf.private_ip]
#   ttl     = "300"
#   type    = "A"
#   zone_id = "YOUR-HOSTED-ZONE-ID"
# }


# resource "aws_eip" "ccf" {
#   instance = module.ec2_instance.id
#   vpc      = true

#   lifecycle {
#     prevent_destroy = false
#   }

#   tags = {
#     Name = "ccf-eip-${var.environment}"
#   }
# }
