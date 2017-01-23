/**
 * Created by root on 11/6/15.
 */


(function(activityService){

    activityService.getActivityById = function(activityId){

        var activity = Parse.Object.extend("Activity");
        var activityQuery = new Parse.Query(activity);

        return activityQuery.get(activityId);
    };

    activityService.getActivity = function(type, fromUser, toUser, remmnant){

        var activity = Parse.Object.extend("Activity");
        var activityQuery = new Parse.Query(activity);

        activityQuery.equalTo("type", type);
        activityQuery.equalTo("fromUser", fromUser);
        activityQuery.equalTo("toUser", toUser);

        if(remmnant){
            activityQuery.equalTo("remnant", remmnant);
        }

        return activityQuery.first();
    };

    activityService.saveActivity = function(type, fromUser, toUser, remnant, content) {

        var Activity = Parse.Object.extend("Activity");
        var activity = new Activity();

        activity.set("type", type);
        activity.set("fromUser", fromUser);
        activity.set("toUser", toUser);
        activity.set("remnant", remnant);
        activity.set("content", content);


        return activity.save();
    };

    var alertMessage = function(request) {
        var message = "";

        if (request.object.get("type") === "comment") {
            if (request.user.get('username')) {
                message = request.user.get('username') + ': ' + request.object.get('content').trim();
            } else {
                message = "Someone commented on your photo.";
            }
        } else if (request.object.get("type") === "like") {
            if (request.user.get('username')) {
                message = request.user.get('username') + ' likes your remnant.';
            } else {
                message = 'Someone likes your photo.';
            }
        } else if (request.object.get("type") === "follow") {
            if (request.user.get('username')) {
                message = request.user.get('username') + ' is now following you.';
            } else {
                message = "You have a new follower.";
            }
        }

        // Trim our message to 140 characters.
        if (message.length > 140) {
            message = message.substring(0, 140);
        }

        return message;
    };

    activityService.alertPayload = function(request) {

        if (request.object.get("type") === "comment") {
            return {
                alert: alertMessage(request), // Set our alert message.
                badge: 'Increment', // Increment the target device's badge count.
                // The following keys help Anypic load the correct photo in response to this push notification.
                p: 'a', // Payload Type: Activityparse
                t: 'c', // Activity Type: Comment
                fu: request.object.get('fromUser').id, // From User
                rid: request.object.get('remnant').id // remmnant Id
            };
        } else if (request.object.get("type") === "like") {
            return {
                alert: alertMessage(request), // Set our alert message.
                badge: 'Increment', // Increment the target device's badge count.
                // The following keys help Anypic load the correct photo in response to this push notification.
                p: 'a', // Payload Type: Activity
                t: 'l', // Activity Type: Like
                fu: request.object.get('fromUser').id, // From User
                rid: request.object.get('remnant').id // remmnant Id
            };
        } else if (request.object.get("type") === "follow") {
            return {
                alert: alertMessage(request), // Set our alert message.
                badge: 'Increment', // Increment the target device's badge count.
                // The following keys help Anypic load the correct photo in response to this push notification.
                p: 'a', // Payload Type: Activity
                t: 'f', // Activity Type: Follow
                fu: request.object.get('fromUser').id // From User
            };
        }
    }


})(module.exports);