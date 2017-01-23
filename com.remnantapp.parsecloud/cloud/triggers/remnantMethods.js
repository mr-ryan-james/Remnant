/**
 * Created by root on 10/9/15.
 */

var Image = require("parse-image");
var _ = require("underscore");
var remnantService = require("cloud/services/remnantService");
var activityService = require("cloud/services/activityService");
var userService = require("cloud/services/userService");

var generateThumbnail = function(remnant){

    var promise = new Parse.Promise();


            if (!remnant.get("photo")) {
                console.log("No photo detected");
                return;
            }

            Parse.Cloud.httpRequest({
                url: remnant.get("photo").url()

            }).then(function(response) {
                var image = new Image();
                return image.setData(response.buffer);

            }).then(function(image) {
                // Resize the image to 150.
                return image.scale({
                    width: 150,
                    height: 150
                });

            }).then(function(image) {
                // Make sure it's a JPEG to save disk space and bandwidth.
                return image.setFormat("JPEG");

            }).then(function(image) {
                // Get the image data in a Buffer.
                return image.data();

            }).then(function(buffer) {
                // Save the image into a new file.
                var base64 = buffer.toString("base64");
                var cropped = new Parse.File("thumbnail.jpg", { base64: base64 });
                return cropped.save();

            }).then(function(cropped) {
                // Attach the image file to the original object.
                remnant.set("thumbnail", cropped);

            }).then(function(result) {
                console.log("thumbnail creation successful");
                promise.resolve(result);
            }, function(error) {
                console.log(error);
                promise.reject(error);
            });



    return promise;
};

var getElevation = function(remnant){
    console.log("getElevation begin");
    var promise = new Parse.Promise();

    var geopoint = remnant.get("geolocation");

    var elevationApiUrl = "https://maps.googleapis.com/maps/api/elevation/json?locations=" + geopoint.latitude + "," + geopoint.longitude + "&key=AIzaSyAZCGksnNLptX07ZVmb7A3nFNZrQv9c-CA";

    console.log("elevation api call to: "+ elevationApiUrl);

    Parse.Cloud.httpRequest({
        url: elevationApiUrl

    }).then(function(response) {
        console.log("getElevation finished with: " + JSON.stringify(response.data));

        var elevation = response.data.results[0].elevation;
        console.log("getElevation result: " + elevation);
        remnant.set("altitude", elevation);
        promise.resolve(elevation);

    });

    return promise;
};


Parse.Cloud.define("postProcessRemnant", function(request, response) {
    var remnantId = request.params.remnantId;

    remnantService.get(remnantId).then(function(remnant){
        return Parse.Promise.when(remnant, generateThumbnail(remnant), getElevation(remnant));
    }).then(function(remnant, thumbnailResult, elevationResult){
        remnant.save();
    }, function(error){
        response.error(error);
    });

});


Parse.Cloud.define("getRemnantForDetailView", function(request, response) {

    var remnantId = request.params.remnantId;
    var currentUser = Parse.User.current();

    var Remnant = Parse.Object.extend("Remnant");
    var remmnant = new Remnant();
    remmnant.id = remnantId;

    var returnedRemnant;
    remnantService.get(remnantId).then(function(remnant){
        if(remnant){
            returnedRemnant = remnant;
            return activityService.getActivity("like", currentUser, remmnant.get("user"), remmnant);
        }
    }).then(function(likeActivity){
       response.success({
           remnant: returnedRemnant,
           userLikeActivity: likeActivity,
           userHasSaved: false
       })
    }, function(error){
        response.error(error);
    });


});


Parse.Cloud.define("likeRemnant", function(request, response) {
    var toUserId = request.params.toUser;
    var remnantId = request.params.remnantId;
    var currentUser = Parse.User.current();

    var toUser = new Parse.User();
    toUser.id = toUserId;

    var Remnant = Parse.Object.extend("Remnant");
    var remmnant = new Remnant();
    remmnant.id = remnantId;

    var savedLikeActivity;
    activityService.saveActivity("like", currentUser, toUser, remmnant).then(function(likeActivity){
        if(likeActivity){
            savedLikeActivity = likeActivity;
            var query = new Parse.Query(Remnant);
            query.select("likes");
            return query.get(remnantId);
        }

        var error = new Error("there was a problem saving like");
        throw error;
    }).then(function(fullRemnantObject){
        fullRemnantObject.set("likes", (fullRemnantObject.get("likes") || 0) + 1);

        return fullRemnantObject.save(null, { useMasterKey: true });
    }).then(function(whoCares){
        response.success(savedLikeActivity);
    }, function(error){
        response.error(error);
    });

});

Parse.Cloud.define("unlikeRemnant", function(request, response) {

    var remnantId = request.params.remnantId;
    var likeActivityId = request.params.likeActivityId;

    activityService.getActivityById(likeActivityId).then(function(likeActivity){
        return likeActivity.destroy();
    }).then(function(){
        return remnantService.get(remnantId)
    }).then(function(remnant){
        var numLikes = remnant.get("likes") || 0;
        if(numLikes <= 0){
            response.error("There are only 0 likes on the object");
            return;
        }

        remnant.set("likes", numLikes - 1);
        return remnant.save(null, { useMasterKey: true });
    }).then(function(whoCares){
        response.success(true);
    }, function(error){
        response.error(error);
    });

});


Parse.Cloud.define("searchForUsername", function(request, response) {

    var foundUser;

    userService.searchByUsername(request.params.username).then(function(user){
        if(!user){
            response.success(null);
            return;
        }

        foundUser = user;
        return activityService.getActivity("follow", Parse.User.current(), user)
    }).then(function(followActivity){
        if(!foundUser){
            return;
        }

        response.success({user: foundUser, followActivity: followActivity});
    }).fail(function(err){
        response.error(err);
    });

});