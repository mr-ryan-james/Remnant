/**
 * Created by ryanpfister on 3/25/15.
 */


(function(remnantService){
	var Remnant = require('../models/remnant.js');
	var q = require("q");
	var sanitizeHtml = require('sanitize-html');
	var cloudinaryService = require("../cloudinary");

	remnantService.saveRemnant = function(req){
		var deferred = q.defer();

		function saveRemnant(imageId, req){
			var remnant = new Remnant({
				userId: req.user.objectId,
				userName: req.user.username,
				image: (imageId ? [imageId]: []),
				title: sanitizeHtml(req.get("title"), {
					allowedTags: []
				}),
				description: sanitizeHtml(req.get("description"), {
					allowedTags: []
				}),
				geolocation: [parseFloat(req.get("lng")), parseFloat(req.get("lat"))]
			});

			remnant.save(function(err, result){
				if(err){
					deferred.reject(err);
					return;
				}

				deferred.resolve(result);
			});
		}

		cloudinaryService.uploadToCloud(req).then(function(result){
			if(result) {
				saveRemnant(result.public_id, req);
			}
			else{
				saveRemnant(null, req);
			}
		}).fail(function(err){
			deferred.reject(err);
			return;
		});

		return deferred.promise;
	};

	remnantService.getRemnant = function(itemId){
		var deferred = q.defer();

		Remnant.findById(itemId, function(err, item){
			if(err){
				deferred.reject(err);
				return;
			}

			deferred.resolve(item);
		});

		return deferred.promise;
	};


	remnantService.search = function(request){
		var deferred = q.defer();

		var query = Remnant
			.where('geolocation').within({ center: [request.lng, request.lat], radius: parseInt(request.distance) / 3963.1676, unique: true, spherical: true })
			.limit(10)
			//.sort('geolocation');
			.sort('-createdOn');

		query.exec(function(err, documents) {
			if(err){
				deferred.reject(err);
				return;
			}

			deferred.resolve({result: documents});
		});

		return deferred.promise;
	};

	remnantService.getForUser = function(userId){
		var deferred = q.defer();

		var query = Remnant.where("userId")
			.equals(userId)
			.sort("-createdOn");

		query.exec(function(err, data){
			if(err){
				deferred.reject(err);
				return;
			}

			deferred.resolve(data);
		});

		return deferred.promise;
	};


})(module.exports);