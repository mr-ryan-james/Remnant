/**
 * Created by root on 11/6/15.
 */


(function(activityService){

    activityService.searchByUsername = function(username){
        var query = new Parse.Query(Parse.User);
        query.equalTo("username", username);
        return query.first()
    };

})(module.exports);