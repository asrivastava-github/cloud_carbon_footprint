resource "aws_security_group" "ccf_instance_sg" {
  name   = "ccf-instance-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_iam_instance_profile" "ccf_instance_profile" {
  name = "ccf-instance-profile"
  role = aws_iam_role.ccf_api_role.name
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ccf_instance_sg.id]
  subnet_id              = var.target_subnet_id
  user_data              = file("${path.module}/src/install-ccf.sh")
  iam_instance_profile   = aws_iam_instance_profile.ccf_instance_profile.name

  tags = var.tags
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
