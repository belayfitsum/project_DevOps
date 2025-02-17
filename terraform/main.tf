# Provider block , the profile is the onely one key in my aws credentials folder
provider "aws" {
  region = "eu-central-1"
  profile = "default"
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

//create subnet in the second az

resource "aws_default_subnet" "subnet_az2"{
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
}
  # create a security group

  resource "aws_security_group" "database_sg" {
  name        = "postgres security group"
  description = "Allow postgresql access on port "
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    description      = "postgres access"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

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
