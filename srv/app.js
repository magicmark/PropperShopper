'use strict';

var app = require('express')();

var bindRoutes = require('./routes')(app);

var port = Number(5000);

function startServer() {
  app.listen(port, function() {
    console.log("Listening on port ", port);
  });
}

startServer();
