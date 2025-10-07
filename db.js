// const { Client } = require('pg');
// const dotenv = require('dotenv');
// dotenv.config();

// const con = new Client({
//     host: process.env.DB_HOST,
//     port: process.env.DB_PORT,
//     user: process.env.DB_USER,
//     password: process.env.DB_PASSWORD,
//     database: process.env.DB_NAME,
//     ssl: { rejectUnauthorized: false }  
// })

// con.connect().then(()=> console.log("connected"))

// // Create table if not exists
// con.query(`
//   CREATE TABLE IF NOT EXISTS ads (
//     id SERIAL PRIMARY KEY,
//     name VARCHAR(100) NOT NULL,
//     email VARCHAR(150) UNIQUE NOT NULL
//   );
// `).then(() => console.log('Table is ready'))
//   .catch(err => console.error('Table creation error:', err));

// module.exports = con;

// New test with sqlite3

// db.sqlite.js
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Always create DB file in project directory
const dbPath = path.resolve(__dirname, 'mydb.sqlite3');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error connecting to SQLite:', err.message);
  } else {
    console.log(`Connected to SQLite database at ${dbPath}`);
    // Create table if it doesn’t exist
    db.run(`
      CREATE TABLE IF NOT EXISTS ads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL
      )
    `);
  }
});

module.exports = db;

