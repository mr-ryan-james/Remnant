/**
 * Created by puhfista on 6/2/15.
 */

var express = require('express');
var router = express.Router();

router.get('/', function(req, res) {
    res.render('index', { title: 'Remnant' });
});

module.exports = router;
