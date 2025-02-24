# Provider block , the profile is the onely one key in my aws credentials folder
provider "aws" {
  region = "eu-central-1"
}

//this holds the terraform state

terraform {
  backend "s3" {
    bucket         = "my-terraform-tfstate12"
    key            = "tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}

# create a default vpc if not exists

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name="rds_vpc"
  }
}

# create a data source to get all availability zones in a region

data "aws_availability_zones" "aws_availability_zones" {}

# create a default subnet in first az if one not exists

resource "aws_default_subnet" "subnet_az1"{
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]
}

//create subnet in the second az. this actually created subnets in all three az's

resource "aws_default_subnet" "subnet_az2"{
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 2be changed later
}
ingress {
    from_port   = 3000  
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open for API access
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
}
tags = {
    Name = "EC2_API_SG"
  }
}
  # security group for posrgres

  resource "aws_security_group" "database_sg" {
  name        = "postgres security group"
  description = "Allow postgresql access on port "
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description      = "postgres access"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [aws_security_group.ec2_sg.id] # only allow ec2 to have access via port
   }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] # this is unncessary

  }

  tags = {
    Name = "postgres security group"
  }
}
 resource "aws_db_subnet_group" "database_subnet_group"{
  name = "database-subnets"
  subnet_ids = [aws_default_subnet.subnet_az1.id, aws_default_subnet.subnet_az2.id]
  description = "subnet for db instance"

tags = {
    Name = "database-subnets"
  }
}

# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                  = "postgres"
  engine_version          = "15"
  multi_az                = false
  identifier              = "postgres-api-testing"
  username                = var.db_username
  password                = var.db_password
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_storage
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids  = [aws_security_group.database_sg.id]
  availability_zone       = data.aws_availability_zones.aws_availability_zones.names[0]
  db_name                 = var.db_name
  skip_final_snapshot     = true
}

# Provision EC2 instance
resource "aws_instance" "my_api_server" {
  ami           = "ami-06ee6255945a96aba"  
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
  key_name =  "postgres"
  vpc_security_group_ids  = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "My API Server"
  }
}
