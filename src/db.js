const { Client } =require('pg')
const express = require('express')

const app = express()

app.use(express.json())

//define a route that listens to requests by making this app a server to get to listen to connections

const port = process.env.PORT || 3000;

const con = new Client({
    host: "localhost",
    port: "5432",
    user: "postgres",
    password:'test12#',
    database:"log"

})
//module.exports = pool

con.connect().then(()=> console.log("connected"))

// Create table if not exists
con.query(`
  CREATE TABLE IF NOT EXISTS log_table (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL
  );
`).then(() => console.log('Table is ready'))
  .catch(err => console.error('Table creation error:', err));

  //route to insert new log into the log table

  app.post('/postData', async (req, res) => {
    const { name, email } = req.body;
    if (!name || !email) return res.status(400).send('name and email is required.');
  
    try {
      const result = await con.query(
        'INSERT INTO log_table (name, email) VALUES ($1, $2) RETURNING *', 
        [name, email]
      );
      res.status(201).json(result.rows[0]);
    } catch (error) {
      result.status(500).send('Error inserting table.');
    }
  });


  app.listen(port, () => {
    console.log(`app is listening on PORT ${port}`);
});