const { Client } = require('pg');
const dotenv = require('dotenv');
dotenv.config();

const con = new Client({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    ssl: { rejectUnauthorized: false }  
})

con.connect().then(()=> console.log("connected"))

// Create table if not exists
con.query(`
  CREATE TABLE IF NOT EXISTS ads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
  );
`).then(() => console.log('Table is ready'))
  .catch(err => console.error('Table creation error:', err));

module.exports = con;
