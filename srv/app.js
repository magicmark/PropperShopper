#!/usr/bin/env node
'use strict';

var app = require('express')();
var bodyParser = require('body-parser');
var busboy = require('connect-busboy');

app.use(busboy()); 

app.use(bodyParser.urlencoded({extended:false}));
var bindRoutes = require('./routes')(app);

var port = Number(5000);

function startServer() {
  app.listen(port, function() {
    console.log("Listening on port ", port);
  });
}

startServer();
