const express = require('express')
const con =require('./db')
const app = express()

app.use(express.json())

app.post('/postData', async (req, res) => {
  const { name, email } = req.body;
  if (!name || !email) return res.status(400).send('name and email is required.');

  try {
    const result = await con.query(
      'INSERT INTO ads (name, email) VALUES ($1, $2) RETURNING *', 
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

// DELETE by name + email
app.delete('/logs', async (req, res) => {
  try {
    const { name, email } = req.body;
    if (!name || !email) {
      return res.status(400).send("Both name and email are required.");
    }

    const result = await con.query(
      'DELETE FROM log_table WHERE name = $1 AND email = $2 RETURNING *',
      [name, email]
    );

    if (result.rowCount === 0) {
      return res.status(404).send(`No log found with name=${name} and email=${email}`);
    }

    res.status(200).send(`Log with name=${name} and email=${email} deleted.`);
  } catch (error) {
    console.error(error);
    res.status(500).send('Error deleting log.');
  }
});


// Start the server on port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});
