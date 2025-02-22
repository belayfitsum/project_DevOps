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

