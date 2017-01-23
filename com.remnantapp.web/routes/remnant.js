/**
 * Created by puhfista on 8/18/15.
 */


var express = require('express');
var router = express.Router();
var remnantService = require("../remnant");
var auth = require("../auth");

router.get('/byRemnantId/:id', function(req, res) {

    remnantService.getRemnant(req.params.id).then(function(results){
        res.send(results);
        res.end();
    }).fail(function(err){
        console.log(err);
        res.status(500).send(err);
        res.end();
    });

});

router.get('/search', function(req, res){
    //var lat = req.query.lat;
    //var lng = req.query.lng;
    //var distance = req.query.distance;

    remnantService.search(req.query).then(function(results){
        res.send(results);
        res.end();
    }).fail(function(err){
        console.log(err);
        res.status(500).send(err);
        res.end();
    });

});

//router.get('/rendered', auth.ensureApiAuthenticated, function(req, res) {
    router.get('/rendered', function(req, res) {

    remnantService.search(req.query).then(function(results){
        res.render('remnants', { title: 'Remnant', remnants: results.result });
    }).fail(function(err){
        console.log(err);
        res.status(500).send(err);
        res.end();
    });

});

router.post('/', auth.ensureApiAuthenticated, function(req, res){

    console.log("attempting to save remnant");

    remnantService.saveRemnant(req).then(function(results){
        res.send(results);
        res.end();
    }).fail(function(err){
        console.log(err);
        res.status(500).send(err);
        res.end();
    });

});

module.exports = router;
