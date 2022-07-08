module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "ccf-aabg"
  cidr = "10.10.0.0/24"

  azs             = ["eu-west-1a"]
  private_subnets = ["10.10.0.0/25"]
  public_subnets  = ["10.10.0.128/25"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Application = "cloud-carbon-footprint"
    Name        = "ccf-aabg"
    Team        = "team-1"
  }
}

resource "aws_s3_bucket" "ccf-aabg" {
  for_each = toset(var.bucket_functions)

  bucket = "${var.prefix}-t1-${each.key}"

  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "ccf_aabg" {
  for_each = toset(var.bucket_functions)

  bucket = aws_s3_bucket.ccf-aabg[each.key].id

  block_public_acls   = true
  block_public_policy = true
}

module "ccf" {
  source = "./modules/cloud-carbon-footprint"

  default_region = data.aws_region.current.name

  # Networking
  vpc_id           = module.vpc.vpc_id
  target_subnet_id = module.vpc.public_subnets[0]

  # EC2
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  application         = var.application
  allowed_cidr_blocks = var.allowed_cidr_blocks

  # S3
  billing_data_bucket_arn         = aws_s3_bucket.ccf-aabg["billing"].arn
  athena_query_results_bucket_arn = aws_s3_bucket.ccf-aabg["athena"].arn


  tags = local.tags

}

