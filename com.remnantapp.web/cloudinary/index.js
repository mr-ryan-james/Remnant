/**
 * Created by ryan on 2/21/15.
 */

(function(cloudinaryService){

    var cloudinary = require('cloudinary');
    var config = require("config").Cloudinary;
    var q = require('q');
    var uuid = require('node-uuid');
	var Busboy = require('busboy');

    cloudinary.config({
        cloud_name: config.cloudName,
        api_key: config.key,
        api_secret: config.secret
    });

	function uploadImage (options){

        var deferred = q.defer();

        console.log("attempting to upload to cloudinary");

        try {
            var stream = cloudinary.uploader.upload_stream(
                function (result) {
                    deferred.resolve(result)
                },
                {
                    public_id: uuid.v4(),
                    crop: 'limit',
                    width: 640,
                    height: 640,
                    format: 'png',
                    eager: [
                        {width: 350, height: 350, crop: 'pad'},
                        {width: 150, height: 150, crop: 'pad'}
                    ]
                    //tags: [options.userId]
                }
            );

            options.fileStream.pipe(stream);
        }
        catch(err){
            defer.reject(err);
        }

        return deferred.promise;
    }

	function url(publicId, options){
        return cloudinary.url(publicId, options);
    }

    function isEmptyFileError(result) {
        return result.error && result.error.http_code == 400;
    }

	cloudinaryService.getUrl = function(publicId, options){
		return url(publicId, options);
	};

	cloudinaryService.uploadToCloud = function(req){
		var deferred = q.defer();

        console.log(JSON.stringify(req.headers));

		var busboy = new Busboy({ headers: req.headers });
        var fileFound = false;
		busboy.on('file', function(fieldname, file, filename, encoding, mimetype) {
            fileFound = true;
            console.log("file found:" + fieldname);
			uploadImage({
				fileStream: file
			}).then(function(result){
                if(isEmptyFileError(result)){
                    deferred.resolve(result);
                    return;
                }
                else if(result.error){
                    deferred.reject(result.error);
                    return;
                }

				//result.thumbnailUrl = url(result.public_id, {width: 170, height: 170, crop: 'pad', secure: true});
				deferred.resolve(result);
			}).fail(function(err){
				deferred.reject(err);
			}).done();
		});
		busboy.on('field', function(fieldname, val, fieldnameTruncated, valTruncated) {
			//console.log('Field [' + fieldname + ']: value: ' + val);
		});
		busboy.on('finish', function() {
			console.log("busboy finish");

            if(!fileFound){
                deferred.resolve(null);
            }
		});
		req.pipe(busboy);

		return deferred.promise;
	};

	cloudinaryService.deleteFromCloud = function(publicId){
		var deferred = q.defer();

		cloudinary.api.delete_resources([publicId],
			function(result){
				deferred.resolve(result);
			});

		return deferred.promise;
	}


})(module.exports);