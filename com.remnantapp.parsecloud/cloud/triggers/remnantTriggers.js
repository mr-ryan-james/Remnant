/**
 * Created by root on 10/9/15.
 */

var remnantService = require("cloud/services/remnantService");
var activityService = require("cloud/services/activityService");
var userService = require("cloud/services/userService");

Parse.Cloud.beforeSave(Parse.User, function(request, response) {
    console.log("Parse.User Parse.Cloud.beforeSave");

    //request.object.set("username", request.object.get("username").toLowerCase());

    response.success();
});


Parse.Cloud.afterSave("Remnant", function(request, response) {
    console.log("Remnant Parse.Cloud.afterSave");


});

Parse.Cloud.beforeSave("Remnant", function(request, response) {
    console.log("Remnant Parse.Cloud.beforeSave");

    response.success();
});

Parse.Cloud.beforeSave("Activity", function(request, response){

    var type = request.object.get("type");
    var fromUser = request.object.get("fromUser");
    var toUser = request.object.get("toUser");

    var acl = new Parse.ACL();
    acl.setPublicReadAccess(true);
    acl.setWriteAccess(fromUser, true);
    acl.setWriteAccess(toUser, true);

    request.object.setACL(acl);

    if(type == "follow"){
        //make sure they aren't already following
        activityService.getActivity(type, fromUser, toUser).then(function(followActivity){
           if(followActivity == null){
               response.success();
               return;
           }

            response.error("There is already a follow activity for this user");
        });
    }
    else if(type == "like"){
        activityService.getActivity(type, fromUser, toUser, request.object.get("remnant")).then(function(likeActivity){
            if(likeActivity == null){
                response.success();
                return;
            }

            response.error("There is already a like activity for this user/remnant combination");
        });
    }
    else{
        response.success();
    }

});

Parse.Cloud.afterSave('Activity', function(request) {
    // Only send push notifications for new activities
    if (request.object.existed()) {
        return;
    }

    var toUser = request.object.get("toUser");
    if (!toUser) {
        throw "Undefined toUser. Skipping push for Activity " + request.object.get('type') + " : " + request.object.id;
        return;
    }

    var query = new Parse.Query(Parse.Installation);
    query.equalTo('user', toUser);

    Parse.Push.send({
        where: query, // Set our Installation query.
        data: activityService.alertPayload(request)
    }).then(function() {
        // Push was successful
        console.log('Sent push.');
    }, function(error) {
        throw "Push Error " + error.code + " : " + error.message;
    });
});

Parse.Cloud.beforeSave(Parse.Installation, function(request, response) {
    Parse.Cloud.useMasterKey();
    if (request.user) {
        request.object.set('user', request.user);
    } else {
        request.object.unset('user');
    }
    response.success();
});