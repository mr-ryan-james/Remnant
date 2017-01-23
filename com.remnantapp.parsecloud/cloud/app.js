
// These two lines are required to initialize Express in Cloud Code.
var express = require('express');
var app = express();
var _ = require('underscore');
var remnantService = require("cloud/services/remnantService");

// Global app configuration section
app.set('views', 'cloud/views');  // Specify the folder to find templates
app.set('view engine', 'ejs');    // Set the template engine
app.use(express.bodyParser());    // Middleware for reading request body


app.get('/api/remnants/rendered', function(req, res){
    try {
        console.log("entered rendered");
        remnantService.search(req.query).then(function(results) {
            res.render('remnants', {title: 'Remnant', remnants: results, _: _});
        });
    }
    catch(err){
        console.log(err);
    }

});

app.get('/api/remnants/', function(req, res) {
    try {
        console.log("entered get remnants");
        remnantService.search(req.query).then(function(results) {
            res.send(results);
        });
    }
    catch(err){
        console.log(err);
    }
});

app.get('/api/remnants/byRemnantId/:id', function(req, res){
    try {
        console.log("entered get remnants");
        remnantService.get(req.params.id).then(function(results) {
            res.send(results);
        });
    }
    catch(err){
        console.log(err);
    }
});


// // Example reading from the request query string of an HTTP get request.
// app.get('/test', function(req, res) {
//   // GET http://example.parseapp.com/test?message=hello
//   res.send(req.query.message);
// });

// // Example reading from the request body of an HTTP post request.
// app.post('/test', function(req, res) {
//   // POST http://example.parseapp.com/test (with request body "message=hello")
//   res.send(req.body.message);
// });

// Attach the Express app to Cloud Code.
app.listen();
