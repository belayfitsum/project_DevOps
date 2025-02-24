# project_DevOps

Building a backend with Javascript and PostgreSQL
and build Node.js API endpoint using Node.js  for users to be able to make CRUD operations into the database mainly using PUT and GET
Node.js- Server-Side Development: Node.js is commonly used for building server-side applications, including:
    -  Web servers (like those built with Express.js).   
    - APIs (that provide data to web and mobile apps).   
    - Backend services.    
  

HTTP Methods
- Define the actions the client wants to make to the server CRUD (GET:POST:PUT:DELETE)

For managing different methods GET, DELETE , PUT etc we need a route handler- API endpoints

Middleware- Code which runs on the server between getting a request and sending a response  use()

Dependencies:

Express and pg for postgress

Rest Client

Install rest client extension from visual studio code for testing API's within the code instead of Postman.

PGAdmin vs Psql

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


Trigger	What Happens	Tool Used
Push to GitHub (git push main)	API is automatically deployed to AWS	GitHub Actions
New Database Request from API	Terraform provisions a new RDS instance	Terraform via API
Code Changes in Terraform Repo	Infrastructure updates automatically	GitHub Actions / CI/CD
CloudWatch / EventBridge Trigger	Auto-scale or update infrastructure	AWS EventBridge

What yo achoeve with the automation
✅ No manual deployment needed → Just push code to GitHub
✅ Ensures API is always up-to-date on AWS EC2
✅ Uses PM2 to keep the API running even after reboots > maybe other options than pm2

Deployment

1. AWS EC2 for API
2. PostgreSQL for Database < this has been ready for a while>

- Make sure EC2 can connect to RDS

- test connection between RDS and EC2
- Install dependencies on EC2 node.js etc

Terraform

Both EC2 and Postges RDS instance are provisioned from the same main.tf.Both are:
- same VPC
- Diffferent subnemt
- Only EC2 chave inbound access to rds
[to comply even more with AWS best security practices, change rds into private subnet]

SSH

SSH in to the new EC2 with the SSK KEY. Change permission to the file using 
- chmod 400 KEY_NAME

itsums-MacBook-Pro Downloads $ ssh -i postgres.pem ec2-user@18.199.169.29
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
[ec2-user@ip-172-31-43-142 ~]$ 

🔹CI/CD Pipeline Overview
RDS and EC2 is deployed to AWS using terraform. Next is automated delivery usibf Githubs's CI/CD
✅ Build the application (install dependencies).
✅ Run Tests (optional but recommended).
✅ Deploy the updated API code to your EC2 instance.
✅ Restart the service to apply changes