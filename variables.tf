variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  default     = "dev"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform state locking"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
}

