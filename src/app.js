const express = require('express')

// use express to create an app and configure it to parse requests with JSON payloads

const app = express()

//define the endpoint GET which has two parameters which defines the path to the API and a call back function()

app.get("/log", (req,res) => {
  const status = {
    "Status" : "Running"
  };
  res.send(status);
});

//define a route that listens to requests by making this app a server to get to listen to connections

const port = process.env.PORT || 3000;

// make the server to listen on specific port

app.listen(port, () => {
    console.log(`app is listening on PORT ${port}`);
});
