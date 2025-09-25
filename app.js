const express = require('express')
const con =require('./db')
const app = express()

app.use(express.json())

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
    res.status(500).send('Error inserting table.');
  }
});

// GET all log entries
app.get('/logs', async (req, res) => {
  try {
    const result = await con.query('SELECT * FROM log_table');
    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error fetching logs.');
  }
});


// Start the server on port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
