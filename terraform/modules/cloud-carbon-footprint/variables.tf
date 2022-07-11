# variable "terraform_state_bucket" {
#   type    = string
#   default = "YOUR-TERRAFORM-STATE-BUCKET-NAME"
# }

variable "default_region" {
  type    = string
  default = "YOUR-DEFAULT-AWS-REGION"
}

variable "vpc_id" {
  type    = string
  default = "YOUR-VPC-ID"
}

variable "ami_id" {
  type    = string
  default = "ami-05cd35b907b4ffe77" # Amazon Linux AMI 2. This changes based on your AWS region.
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type    = string
  default = "ccf-aabg-kp"
}

variable "target_subnet_id" {
  type    = string
  default = "YOUR-PRIVATE-SUBNET-ID"
}

variable "application" {
  type    = string
  default = "ccf"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "dns_name" {
  type    = string
  default = "ccf"
}

variable "allowed_cidr_blocks" {
  type    = list(string)
  default = ["YOUR-ALLOWED-CIDR-BLOCK-1", "YOUR-ALLOWED-CIDR-BLOCK-2", "YOUR-ALLOWED-CIDR-BLOCK-3"]
}

variable "billing_data_bucket_arn" {}
variable "athena_query_results_bucket_arn" {}

variable "tags" {}
