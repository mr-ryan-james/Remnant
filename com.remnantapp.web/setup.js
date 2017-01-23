/**
 * Created by puhfista on 9/17/15.
 */

var routes = require('./routes/index');
var path = require('path');
var bodyParser = require('body-parser');
var favicon = require('serve-favicon');
var remnant = require("./routes/remnant");
var data = require("./data");
var express = require('express');

(function (setup) {

    setup.init = function (app) {

        data.init();

// view engine setup
        app.set('views', path.join(__dirname, 'views'));
        app.set('view engine', 'ejs');


//app.use(favicon(__dirname + '/public/favicon.ico'));
//app.use(logger('dev'));
        app.use(bodyParser.json());
        app.use(bodyParser.urlencoded({extended: false}));
//app.use(cookieParser());
//app.use(useragent.express());
        app.use('/js', express.static(__dirname + '/public/js'));
        app.use('/js', express.static(__dirname + '/public/font'));
//app.use('/lib', express.static(__dirname + '/public/lib'));
        app.use('/css', express.static(__dirname + '/public/css'));
//app.use('/html', express.static(__dirname + '/public/html/'));
        app.use('/img', express.static(__dirname + '/public/img'));
        app.use('/favicon.ico', express.static(__dirname + '/public/favicon.ico'));
//app.use(session({
//    name: 'remnant',
//    secret: 'past salad',
//    resave: false,
//    saveUninitialized: true
//}));


        app.use('/', routes);
        app.use('/remnant', remnant);


// catch 404 and forward to error handler
        app.use(function (req, res, next) {
            var err = new Error('Not Found');
            err.status = 404;
            next(err);
        });

// error handlers

// development error handler
// will print stacktrace
        if (app.get('env') === 'development') {
            app.use(function (err, req, res, next) {
                res.status(err.status || 500);
                res.render('error', {
                    message: err.message,
                    error: err
                });
            });
        }

// production error handler
// no stacktraces leaked to user
        app.use(function (err, req, res, next) {
            res.status(err.status || 500);
            res.render('error', {
                message: err.message,
                error: {}
            });
        });


    };

})(module.exports);