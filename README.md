# Project Overview

This project builds a Node.js + Express API with a PostgreSQL database (RDS) to record user data.  
It also includes a **CI/CD pipeline** with GitHub Actions and **infrastructure as code** using Terraform on AWS.

## Features

- REST API with CRUD support (POST, GET)
- Automated provisioning of AWS infrastructure (EC2 + RDS)
- Continuous deployment with GitHub Actions
- Secure connection via OIDC + IAM roles
- **PM2** (process manager to keep API running)

docker build -t dockerusername/project . # to build the app
docker run -p 3000:3000 IMAGE_ID # to containerize it

#### Important Commands

1. docker build -t dockerusername/project . - for internal testing

2. docker run -p 3000:3000 IMAGE_ID - to containerize 

3. Start / restart postgres - MacOs
 **brew services start postgresql** 

4. verify psql listening on port 5432

**lsof -i :5432**

3. Connect to via psql (CLI)- local or inside EC2 instance
**psql -U postgres -h localhost -p 5432**

If it does not work edit <usr/local/var/postgres/postgresql.conf > and uncomment below entry and put a star

**listen_addresses = '*'**

After connecting, check available databases using:
\l
or in PGAdmin navigate to servers > PostGresSQL >Database

4. Create database :
  CREATE DATABASE mydatabase;\

5. Connect to database:

    **\c mydatabase**

6. Test connectivity from EC2

    **psql -h rds_endpoint -U postgres -d log -p 5432**

# Deployment to AWS

1. Provision Infrastructure

- terraform apply creates EC2 + RDS in the same VPC.

- RDS runs in a private subnet, EC2 has access.

2. CI/CD Pipeline

- On git push main, GitHub Actions:

  - Runs Terraform

  - Deploys API code to EC2 via SSH

  - Restarts API with PM2

3. PM2 Process Management

    **pm2 start app.js --name myapp** \
    **pm2 restart myapp --update-env** \
    **pm2 logs myapp**

### Test  the API

  1. Local

    curl -X POST http://localhost:3000/postData \
    -H "Content-Type: application/json" \
    -d '{"name":"dani","email":"dani@example.com"}'

  2. Ec2

    curl -X POST http://PUBLIC_IP:3000/postData \
    -H "Content-Type: application/json" \
    -d '{"name":"Dani","email":"dani@example.com"}'

  3. GET

    http://localhost:3000/logs
    http://PUBLIC_IP:3000/logs

# Important Notes

- Add EC2 SSH public key into GitHub → enables repo cloning via Actions.(after ec2 is provisioned, SSH and generate a key)
- Store Terraform state in S3 for consistency
- If Github role for OIDC miss permissions during terraform apply, just add enough inline policies.
- Security group between EC2 and postgres. Postgress must have ingress rule to allow ec2 security group.
- Master password on RDS and .env must be same
