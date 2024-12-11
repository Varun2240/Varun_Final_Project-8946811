# Terraform Infrastructure Setup

This repository contains Terraform configurations to provision AWS infrastructure, including a VPC, EC2 instance, S3 bucket for state management, and a DynamoDB table for state locking.

## Overview

The setup includes the following resources:
- **VPC**: A custom Virtual Private Cloud (VPC) with DNS support and hostnames.
- **Subnet**: A public subnet within the VPC.
- **Security Group**: A security group allowing SSH (port 22) and HTTP (port 80) access.
- **EC2 Instance**: A t2.micro EC2 instance for your application.
- **S3 Bucket**: For storing Terraform state (using versioning).
- **DynamoDB Table**: For state locking to prevent concurrent modifications.

## Prerequisites

Before running the Terraform configurations, make sure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- AWS CLI with configured credentials (`aws configure`)
- An AWS account with appropriate permissions

## Configuration

### Variables
You can configure the following variables in the `terraform.tfvars` file:
- **region**: The AWS region where the infrastructure will be deployed (e.g., `us-west-2`).
- **s3_bucket_name**: Name of the S3 bucket for storing Terraform state.
- **dynamodb_table_name**: Name of the DynamoDB table for state locking.
- **ami_id**: The AMI ID for the EC2 instance.
- **vpc_cidr**: The CIDR block for the VPC (e.g., `10.0.0.0/16`).
- **public_subnet_cidr**: The CIDR block for the public subnet (e.g., `10.0.1.0/24`).
- **environment**: Environment name (e.g., `development`, `production`).

### Example `terraform.tfvars`
```hcl
region               = "us-west-2"
s3_bucket_name       = "my-terraform-state-bucket"
dynamodb_table_name  = "my-terraform-lock-table"
ami_id               = "ami-xxxxxxxxxxxxxxxxx"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
environment          = "development"


git clone https://github.com/yourusername/terraform-infrastructure.git
cd terraform-infrastructure


terraform init

terraform apply

Review the output and type yes to confirm the creation of resources.

terraform destroy
