
# create a default vpc if not exists

data "aws_availability_zones" "aws_availability_zones" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "rds_vpc"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.aws_availability_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private subnet for az1
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]

  tags = {
    Name = "private-subnet-a"
  }
}

# Private subnet for az2
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]

  tags = {
    Name = "private-subnet-b"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "igw"
  }
}

# Route table for public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for EC2- API server
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.my_vpc.id

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
    cidr_blocks = ["0.0.0.0/0"] # Open for API access
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-sg"
  }
}
# security group for posrgres

resource "aws_security_group" "database_sg" {
  name        = "postgres security group"
  description = "Allow postgresql access from API server-ec2 "
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "postgres access"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id] # only allow ec2 to have access via port
  }
  tags = {
    Name = "postgres-sg"
  }
}
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "database-subnets"
  subnet_ids  = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
    ]
  description = "subnet for db instance"

  tags = {
    Name = "database-subnets"
  }
}

# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                 = "postgres"
  engine_version         = "15"
  identifier             = "postgres-api-testing"
  username               = var.db_username
  password               = var.db_password
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_storage
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.id
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_name                = var.db_name
  skip_final_snapshot    = true
  multi_az = true
}

# Provision EC2 instance
resource "aws_instance" "my_api_server" {
  ami                    = "ami-06ee6255945a96aba"
  instance_type          = "t2.micro"
  key_name               = "postgres"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "My API Server"
  }
}
