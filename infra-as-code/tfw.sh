#!/bin/bash

# Set AWS_PROFILE environment variable
export AWS_PROFILE="personal-aws-account"

# Initialize Terraform
terraform init -upgrade=true -reconfigure -compact-warnings

# Check the first argument passed to the script
if [ "$1" = "apply" ]; then
    # Execute Terraform plan and apply changes
    terraform plan
    terraform apply -auto-approve
elif [ "$1" = "destroy" ]; then
    # Destroy Terraform-managed infrastructure
    terraform destroy -auto-approve
else
    echo "Invalid argument. Please use 'apply' to apply changes or 'destroy' to destroy the environment."
fi
