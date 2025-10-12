// const express = require('express')
// const con =require('./db')
// const app = express()

// app.use(express.json())

// // Example for a Node.js/Express app using the 'pg' library
// console.log("DB_HOST:", process.env.DB_HOST);
// console.log("DB_USER:", process.env.DB_USER);
// console.log("DB_PASS (first 3 chars):", process.env.DB_PASSWORD ? process.env.DB_PASSWORD.substring(0, 3) : 'NOT SET');
// // ... then proceed with db connection

// app.post('/postData', async (req, res) => {
//   const { name, email } = req.body;
//   if (!name || !email) return res.status(400).send('name and email is required.');

//   try {
//     const result = await con.query(
//       'INSERT INTO ads (name, email) VALUES ($1, $2) RETURNING *', 
//       [name, email]
//     );
//     res.status(201).json(result.rows[0]);
//   } catch (error) {
//     res.status(500).send('Error inserting table.');
//   }
// });

// // GET all log entries
// app.get('/logs', async (req, res) => {
//   try {
//     const result = await con.query('SELECT * FROM ads');
//     res.json(result.rows);
//   } catch (error) {
//     console.error(error);
//     res.status(500).send('Error fetching logs.');
//   }
// });

// // DELETE by name + email
// app.delete('/logs', async (req, res) => {
//   try {
//     const { name, email } = req.body;
//     if (!name || !email) {
//       return res.status(400).send("Both name and email are required.");
//     }

//     const result = await con.query(
//       'DELETE FROM ads WHERE name = $1 AND email = $2 RETURNING *',
//       [name, email]
//     );

//     if (result.rowCount === 0) {
//       return res.status(404).send(`No log found with name=${name} and email=${email}`);
//     }

//     res.status(200).send(`Log with name=${name} and email=${email} deleted.`);
//   } catch (error) {
//     console.error(error);
//     res.status(500).send('Error deleting log.');
//   }
// });


// // Start the server on port 3000
// const PORT = process.env.PORT || 3000;
// app.listen(PORT, '0.0.0.0', () => {
//   console.log(`Server running on port ${PORT}`);
// });


// New test with sqlite3

// app.js
const express = require('express');
const db = require('./db'); // Import DB connection
const app = express();
app.use(express.json());

// POST: Insert new record
app.post('/postData', (req, res) => {
  const { campaign_name, status } = req.body;
  if (!campaign_name || !status) return res.status(400).send('campaign_name and status are required.');

  db.run(
    `INSERT INTO ads (campaign_name, status) VALUES (?, ?)`,
    [campaign_name, status],
    function (err) {
      if (err) {
        console.error(err.message);
        return res.status(500).send('Error inserting into ads table.');
      }
    }
  );
});

// GET: Fetch all records
app.get('/logs', (req, res) => {
  db.all(`SELECT * FROM ads`, [], (err, rows) => {
    if (err) {
      console.error(err.message);
      return res.status(500).send('Error fetching logs.');
    }
    res.json(rows);
  });
});

// DELETE: Remove record by campaign_name and status
app.delete('/logs', (req, res) => {
  const { campaign_name, status } = req.body;
  if (!campaign_name || !status) {
    return res.status(400).send("Both campain_id and adset_id are required.");
  }

  db.run(
    `DELETE FROM ads WHERE campaign_name = ? AND status = ?`,
    [campaign_name, status],
    function (err) {
      if (err) {
        console.error(err.message);
        return res.status(500).send('Error deleting campaign.');
      }

      if (this.changes === 0) {
        return res.status(404).send(`No log found with name=${campaign_name} and status=${status}`);
      }

      res.status(200).send(`Log with campaign_name=${campaign_name} and status=${status} deleted.`);
    }
  );
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on port ${PORT}`);
});

