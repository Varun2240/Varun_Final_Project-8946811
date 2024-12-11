# Provider Configuration
provider "aws" {
  region = var.region
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.s3_bucket_name
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Terraform State Bucket"
    Environment = var.environment
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "terraform_state_block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = var.environment
  }
}

# VPC Configuration
resource "aws_vpc" "custom_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "Custom VPC"
    Environment = var.environment
  }
}

# Public Subnet Configuration
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet"
    Environment = var.environment
  }
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name        = "Internet Gateway"
    Environment = var.environment
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "Public Route Table"
    Environment = var.environment
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group to Allow SSH and HTTP Access
resource "aws_security_group" "allow_ssh_http" {
  name        = "Allow-SSH-HTTP"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Allow SSH and HTTP"
    Environment = var.environment
  }
}

# EC2 Instance Configuration
resource "aws_instance" "example" {
  ami                    = var.ami_id        # Ensure this is properly defined
  instance_type          = "t2.micro"  
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet.id
  
  
  vpc_security_group_ids     = ["sg-03b9580d8e6538501"]

  tags = {
    Name        = "Varun Final Project-Terraform EC2 Instance"
    Environment = var.environment
  }
}

output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.example.private_ip
}
