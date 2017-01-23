/**
 * Created by puhfista on 8/18/15.
 */

(function(data){

    var mongoose = require ("mongoose");
    var config = require("config");


    data.init = function(){
        mongoose.connect("mongodb://"+ config.mongodb.user+":"+ config.mongodb.pass+"@" + config.mongodb.instance);
    };


})(module.exports);