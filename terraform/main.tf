# Provider block , the profile is the onely one key in my aws credentials folder
provider "aws" {
  region = "eu-central-1"
  profile = "default"
}

resource "my_ec2" "postgres_instance" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type ="t2.micro"
  key_name ="postgres"
  security_groups ="postgresSG"


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

}
  #user_data = "${file("db.sh")}"

 