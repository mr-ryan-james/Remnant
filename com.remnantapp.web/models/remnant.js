/**
 * Created by ryanpfister on 3/10/15.
 */

var mongoose = require( 'mongoose' );
require('mongoose-long')(mongoose);
var Schema = mongoose.Schema;
var _ = require('underscore');
var shortid = require('shortid');
var SchemaTypes = mongoose.Schema.Types;


var remnantSchema = new Schema({
	_id: {
		type: String,
		unique: true,
		'default': shortid.generate
	},
	userId: {
		type:  String,
		index: true,
		required: true
	},
	userName: {
		type:  String,
		required: true
	},
	image: {
		type: [String]
	},
	title: {
		type: String,
		required: true,
		trim: true
	},
	description:{
		type: String,
		required: true,
		trim: true
	},
	geolocation: {
		type: [Number],
		index: '2dsphere',
		required: true
	},
	createdOn: {
		type: Date,
		default: Date.now
	}
});

var model = mongoose.model('Remnant', remnantSchema );

model.collection.ensureIndex({ geolocation: '2dsphere' }, function(err,a,b,c){
	var whatev = err;
});

module.exports = model;