# Provider block , the profile is the onely one key in my aws credentials folder
provider "aws" {
  region = "eu-central-1"
  profile = "default"
}

resource "aws_vpc" "famvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name="production"
  }
}

# internet gatewy

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.famvpc.id

}

# create a route table

resource "aws_route_table" "fam-route-table" {
  vpc_id = aws_vpc.famvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

}

# create a subnet

resource "aws_subnet" "subnet-fam" {
  vpc_id     = aws_vpc.famvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "prod_subnet"
  }
}
# route table association - route table-subnet

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-fam.id
  route_table_id = aws_route_table.fam-route-table.id
}
  # create a security group

  resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.famvpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }
   ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }
   ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
# networ interfce

resource "aws_network_interface" "webserver-nic" {
  subnet_id       = aws_subnet.subnet-fam.id
  private_ips     = ["10.0.1.55"]
  security_groups = [aws_security_group.allow_tls.id]

}

# assign public elastic ip

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.webserver-nic.id
  associate_with_private_ip = "10.0.1.55"
  depends_on                = [aws_internet_gateway.gw]
}

output "server_public_ip" {
     value = aws_eip.one.public_ip
  }

# create ec2 webserveand deploy an appache webserver

resource "aws_instance" "web-server-insta" {
  ami= "ami-099da3ad959447ffa"
  instance_type ="t2.micro"
  availability_zone= "eu-central-1a"
  key_name= "webserver-key"


  network_interface{
    device_index= 0
    network_interface_id = aws_network_interface.webserver-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y postgresql postgresql-contrib nodejs npm
              git clone https://github.com/myrepo/backend.git /home/ubuntu/backend
              cd /home/ubuntu/backend
              npm install
              npm run build
              npm start
              EOF