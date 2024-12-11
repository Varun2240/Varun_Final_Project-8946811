region              = "us-east-1"
environment         = "dev"
s3_bucket_name      = "varun-final-project"
dynamodb_table_name = "varun-final-project-lock"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"

ami_id              = "ami-0028d7b894e925917"  
instance_type       = "t2.micro"  
key_name            = "varun-final-project"  