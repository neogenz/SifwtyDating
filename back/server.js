'use strict';
var env = process.env.NODE_ENV || "development",
  dbConfig = require('./config/database.json')[env],
  endpointConfig = require('./config/endpoint.json')[env],
  dbURI = __dirname + "/db/" + dbConfig.sqlite.name,
  express = require('express'),
  morgan = require('morgan'),
  bodyParser = require('body-parser'),
  bcrypt = require('bcrypt'),
  cors = require('cors'),
  sqlite3 = require('sqlite3').verbose(),
  app = express(),
  db = null;

// configuration ==============================================================
app.set('port', process.env.PORT || endpointConfig.portNumber);
app.use(bodyParser.json());// get information from html forms
app.use(bodyParser.urlencoded({extended: true}));
app.use(morgan('dev'));

process.env.JWT_SECRET = 'esimedswiftydatingproject';
app.use(cors({credentials: true, origin: true}));

// Run server ==================================================================

var db = new sqlite3.Database(dbURI, sqlite3.OPEN_READWRITE | sqlite3.OPEN_CREATE, function (err) {
  if (err) {
    throw err;
  }

  db.serialize(function () {
    db.run("DROP TABLE IF EXISTS client");
    db.run("CREATE TABLE client (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, username TEXT UNIQUE, password TEXT)");
    var stmt = db.prepare("INSERT INTO client (email, username, password) VALUES (?, ?, ?)");
    stmt.run("maxime.desogus@gmail.com", "neogenz", "esimed");
    db.run("DROP TABLE IF EXISTS challenge");
    db.run("CREATE TABLE challenge (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, token TEXT)");
  });

  require('./controllers/ClientControllerProvider')(app, db);

  app.listen(app.get('port'));

  console.log('Express server listening on port ' + app.get('port'));
});