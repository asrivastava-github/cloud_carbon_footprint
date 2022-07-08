#!/usr/bin/env bash

cd terraform/ && pwd

# Terraform workflow
terraform init --reconfigure
terraform plan -var-file tfvars/terraform.tfvars
terraform apply -var-file tfvars/terraform.tfvars
