/**
 * Created by puhfista on 6/2/15.
 */

var setup = require("./setup");
var http = require('http');
var express = require('express');

var app = express();
var server = http.createServer(app);

var port = parseInt(process.env.PORT, 10) || 9011;
app.set('port', port);
server.listen(port);

setup.init(app);

module.exports = app;