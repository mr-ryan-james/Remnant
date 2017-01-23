(function (auth){

	var config = require('config');
	var request = require("request");


	auth.ensureApiAuthenticated = function(req, res, next){

		var parseSessionId = req.get("sessionToken");

		var options = {
			url: 'https://api.parse.com/1/users/me',
			headers: {
				'X-Parse-Session-Token': parseSessionId,
				'X-Parse-REST-API-Key': config.Parse.restKey,
				'X-Parse-Application-Id': config.Parse.applicationId
			},
			json: true
		};

		request(options, function(err, response, body){

			if(err){
				console.log(err);
				res.status(500).send(err);
				res.end();
				return;
			}

			if(body.error){
				console.log(body.error);
				res.status(500).send(body.error);
				res.end();
				return;
			}

			req.user = body;

			next();
		});
	};


})(module.exports);