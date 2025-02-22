const express = require('express')
const pool =require('./db')
const app = express()

// important as we define what data -we are requesting through GET
app.use(express.json()),
//define the endpoint GET which has two parameters which defines the path to the API and a call back function()
app.get("/log", (req,res) => {
  const status = {
    "Status" : "Running"
  };
  res.send(status);
});
//POST route

// app.post("/log", async(req, res) =>{
//  const {name, status } = req.body
//  try {
//   await pool.query('INSERT INTO log (name, status) VALUES ($1,$2)', [name,status])
//   res.status(200).send({message:" entry added"})
//  } catch (err) {
//   console.log(err)
//   res.sendStatus(500)
// }//
// });

//calling pstgess function
app.get("/setup", async(req, res) =>{
  try {
      await pool.query('CREATE TABLE anotherlog(id SERIAL PRIMARY KEY, name VARCHAR(100), status VARCHAR(100))')
  } catch (err) {
    console.log(err)
    res.sendStatus(500)
  }
});
//define a route that listens to requests by making this app a server to get to listen to connections

const port = process.env.PORT || 3000;

// make the server to listen on specific port

app.listen(port, () => {
    console.log(`app is listening on PORT ${port}`);
});
