/**
 * Created by root on 10/9/15.
 */


(function(remnantService){

    remnantService.search = function(queryString){
        var distance = parseFloat(queryString.distance || "10");

        var query = new Parse.Query("Remnant");
        var point = new Parse.GeoPoint({
            latitude: parseFloat(queryString.lat),
            longitude: parseFloat(queryString.lng)
        });
        query.withinMiles("geolocation", point, distance);
        query.descending("createdAt");
        return query.find();

    };

    remnantService.get = function(id){
        var query = new Parse.Query("Remnant");
        return query.get(id);
    };

})(module.exports);