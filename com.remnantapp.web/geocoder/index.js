/**
 * Created by ryanpfister on 3/25/15.
 */

(function(geocoderService){
	var config = require("config");
	var geocoder = require('node-geocoder').getGeocoder('google', 'https', {
		apiKey: config.Google.apiKey,
		formatter: null
	});
	var q = require('q');


	geocoderService.getCoords = function(fullAddress){
		var deferred = q.defer();

		geocoder.geocode(fullAddress)
			.then(function(geocodeRes) {
				deferred.resolve(geocodeRes)

			}).catch(function(err){
				deferred.reject(err);
			});

		return deferred.promise;

	};

	geocoderService.reverseLookup = function(coords){
		var deferred = q.defer();
		geocoder.reverse(coords.lat, coords.lng)
			.then(function(geoResponse) {

				if(geoResponse.length > 0){
					deferred.resolve(geoResponse[0]);
				}

				deferred.reject("No data");
			})
			.catch(function(err) {
				deferred.reject(err);
			});

		return deferred.promise;
	};


})(module.exports);