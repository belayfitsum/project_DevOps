# project

To Create a backend using Javascript and a PostgreSQL database with one table named “log”, including building Node.js API endpoints to enable users to perform CRUD operations on the database, primarily utilizing PUT and GET requests. In addition a CI/CD pipeline using GitHub actions/Gitlab to run test and deploy the backend using infrastructure as code in AWS

Node.js- Server-Side Development: Node.js is commonly used for building server-side applications, including:
    -  Web servers (like those built with Express.js).   
    - APIs (that provide data to web and mobile apps).   
    - Backend services.    
  

HTTP Methods
- Define the actions the client wants to make to the server CRUD (GET:POST:PUT:DELETE)

For managing different methods GET, DELETE , PUT etc we need a route handler- API endpoints

Middleware- Code which runs on the server between getting a request and sending a response  use()

# Dependencies:

- Express and pg for postgress

- PGAdmin vs Psql

pgAdmin is a graphical user interface (GUI) tool for managing and interacting with PostgreSQL databases. It provides an alternative to using psql (the command-line tool), making it easier to view, create, modify, and manage databases visually. 

Important commands:
1. Start / restart postgres - MacOs
<brew services start postgresql>

2. verify psql listening on port 5432

<lsof -i :5432>

3. Connect to via psql (CLI)
<psql -U postgres -h localhost -p 5432>

If it does not work edit <usr/local/var/postgres/postgresql.conf > and change the uncomment below entry and put a star

<listen_addresses = '*'>

After connecting, check available databases using:
\l
or in PGAdmin navigate to servers > PostGresSQL >Database

4. Create database :
CREATE DATABASE mydatabase;

5. Connect to database:

\c mydatabase

6. Start the API
nodemon db/ node db.api

- Rest Client

Installed rest client extension from visual studio code for testing API's within the code instead of Postman.

# Nodemon 
Nodemon is a development tool that automatically restarts a Node.js application when file changes in the directory are detected. It helps developers by eliminating the need to manually restart the server after making code changes.

Trigger	What Happens	Tool Used
Push to GitHub (git push main)	API is automatically deployed to AWS	GitHub Actions
New Database Request from API	Terraform provisions a new RDS instance	Terraform via API
Code Changes in Terraform Repo	Infrastructure updates automatically	GitHub Actions / CI/CD
CloudWatch / EventBridge Trigger	Auto-scale or update infrastructure	AWS EventBridge

What to achieve with the automation
✅ No manual deployment needed → Just push code to GitHub
✅ Ensures API is always up-to-date on AWS EC2
✅ Uses PM2 to keep the API running even after reboots > maybe other options than pm2?

Deployment

1. AWS EC2 for API
2. PostgreSQL for Database 

- Make sure EC2 can connect to RDS

- test connection between RDS and EC2
- Install dependencies on EC2 node.js etc

# Terraform

Both EC2 and Postges RDS instance are provisioned from the same main.tf.Both are:
- same VPC
- Diffferent subnent
- Only EC2 chave inbound access to rds
[to comply even more with AWS best security practices, change rds into private subnet]

# SSH

SSH in to the new EC2 with the SSK KEY. Change permission to the file using 
- chmod 400 KEY_NAME

 $ ssh -i postgres.pem ec2-user@IP


Install dependencies once SSH like nodejs, pm2 to restart API automatically
# sudo dnf install nodejs -y
# sudo npm install -g pm2

🔹CI/CD Pipeline Overview
RDS and EC2 is deployed to AWS using terraform. Next is automated delivery using Githubs's CI/CD
✅ Build the application (install dependencies).
✅ Run Tests (optional but recommended).
✅ Deploy the updated API code to your EC2 instance.
✅ Restart the service to apply changes

NOTE:

When running CICD pipline terraform created another EC2 instance.The existing instance was created from default profile and the state was locally saved.
Fix this by using an S3 backend to store Terraform state:

Added below in head of the main.tf file after creating the s3 bucket,
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "infra/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}
However run into pipline failure 
Run terraform init
/home/runner/work/_temp/d9f68749-b436-4e4a-8cf9-8c3167d576d8/terraform-bin init
Initializing the backend...
╷
│ Error: No valid credential sources found
│ 
│ Please see https://www.terraform.io/docs/language/settings/backends/s3.html
│ for more information about providing credentials.
│ 
│ Error: failed to refresh cached credentials, no EC2 IMDS role found,
│ operation error ec2imds: GetMetadata, failed to get API token, operation
│ error ec2imds: getToken, http response error StatusCode: 400, request to
│ EC2 IMDS failed
│ 
Solution: 
Read the failure throughly. Failures mainly happen due to the Github role in AWS having no privillages on deploying some resources. The only way is to add the specific policy from AWS to the github role.

NOTE:

my ec2 ssh public key is added to github to be able to clone it.
Steps
- generate ssh from the ec2 and add it to Github <<<detai steps later>>>
|ssh-keygen -t rsa > copy the public key > 
|github >settings >SSH and GPG keys > paste the public key

It's only after adding pub key to github that it has privillages to ssh into ec2 using the github actions < concepts of passwordless SSH>
But what is the point of pm2 restarting the API ? shouldn't the CICD handle that?

- OpenIdConnect(OICD)

github actions used a role designated from AWS IDP to deploy resources on aws cloud. 
OpenID Connect (OIDC) allows your GitHub Actions workflows to access resources in Amazon Web Services (AWS), without needing to store the AWS credentials as long-lived GitHub secrets. https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services

S3
s3 backend for terraform must be created before hand or within the terraform initialization. 

Testing te API:

Option 1

1. Add Rest client extension from VS code and test it locally in format below

###
POST http://localhost:3000/postData

Content-Type: application/json

{
   "name":"xxx",
   "email":"xxx.com"
}

- You can also check from PGAdmin desktop client if the entry is added to the database or from the from localhost or API node respectively below.
<psql -h localhost -U postgres -d log -W>
<psql -h <PostgreSQL endpoint> -U postgres -d log -W>

When endpoint is hit, the action should be reflected in the databse. Since I have firewall openings open from API node to RDS instance I can check the entry from AWS EC2 node with above command

Improvemnets:

Add a GET endpoint - to fetch all the data!! in progress


Option 2.

- Open postman and enter the URL as defined in the endpoint section of the application. Use method POST

POST http://localhost:3000/postData

