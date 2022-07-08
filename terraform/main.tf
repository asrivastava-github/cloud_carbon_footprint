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
    Terraform = "true"
    Application = "cloud-carbon-footprint"
    Name = "ccf-aabg"
    Team = "team-1"
  }
}
