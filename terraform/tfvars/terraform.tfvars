environment         = "dev"
prefix              = "ccf-aabg"
ami_id              = "ami-0d71ea30463e0ff8d"
instance_type       = "t2.medium"
key_name            = "ccf-aabg-kp"
application         = "cloud-carbon-footprint"
allowed_cidr_blocks = ["0.0.0.0/0"]
bucket_functions    = ["billing", "athena"]
