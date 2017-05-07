/**
 * This is the server side code for Iconified Project.
 * The codes are used to running a server for accepting API calls
 * and return data that will be displayed by Client side.
 * The server will use Google APIs for a few locations queries.
 * Besides, the code also use  mongoDB for General Practitioners 
 * queries.
 * 
 * The APIs currently include: /emergency, /test, /apitest and
 * /testpy.
 * 
 * Author: Tiankun Lu 
 * Version: 0.1
 */



//using express package for server construction.
const express = require("express");
//using bodyParser package for query parser.
const bodyParser = require("body-parser");
//using https package for Google API query.
const https = require("https");
//using async package for organize the asyncronizing workflow.
const async = require("async");
//Create the app from express framework.
const app = express();
//import MongoClient package for MongoDB connection.
const MongoClient = require("mongodb").MongoClient;
//import PythonShell for running python scripts in Javascript.
var PythonShell = require('python-shell');
//import keys to the app.
var mykey = require("./keylist.js");
console.log(mykey);

//MongoDB instance initiation.
var mdb;

//apply bodyparser.
app.use(bodyParser.urlencoded({extended:true}));

//Initiating the server, port 3000 is listening.
app.listen(3000, () => {
    console.log('listening on 3000')
})

/* 
 *function for check undefined values, return true or false.
 */
function checkUnd(theValue){
	if(typeof(theValue) ==="undefined"){
		return "unavailable";
	}else{
		if(theValue.open_now){
			return "true";
		}else{
			return "false";
		}
	}
}

/* 
 *function for check the result values.
 *return true for value "OK"
 *return false for other values.
 */
function checkResu(result){
	if (result.status === "OK"){
		return true;
	}else{
		return false;
	}
}

/* 
 *Initiating a data model for storing the data retrieved from
 *Google API.
 */
function thePlace(){
	this.place_id = "";
	this.name = "";
	this.location = "";
	this.open_now = "";
	this.address = "";
	this.numbers = "";
	this.rating = "";
	this.price_level = "";
	this.website = "";
	this.url = "";
	this.photos = "";
}

/* 
 *Function for retrieving the basic venue information around a given
 *location.
 *It can be used for different search type. For example:
 *food, atm, etc.
 */
function basicInfo(type,location,keyword,callback){
	var final = [];
	var atype = type;
	var alocation = location;
	var thekeyword = keyword;
	var purl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+ alocation +"&types="+atype + "&rankby=distance" + "&key="+mykey;
	if(keyword){purl = purl + '&keyword=' + thekeyword};
	https.get(purl, function(response) {
		var body ="";
		response.on('data', function(chunk) {
			body += chunk;
		})
		response.on('end', function () {
			//Store the data from google apis to local data instance.
			places = JSON.parse(body);
			var results = places.results;
			for (i=0;i<results.length;i++){
				//Record the first 10 results.
				var myPlace = new thePlace();
				myPlace.name = results[i].name;
				myPlace.location = results[i].geometry.location;
				myPlace.open_now = checkUnd(results[i].opening_hours);
				myPlace.place_id = results[i].place_id;
				myPlace.price_level = results[i].price_level;
				myPlace.rating = results[i].rating;
				final.push(myPlace);
			}
			callback(null,final);
		})
	})
}
/* 
 *function for retrieving detailed information based on
 *a given google place ID. Including address, numbers, 
 *websites, etc.
 */
function detailedInfo(final,callback){
	//Initiating a counter.
    var count = 0;
	for (i=0;i<final.length;i++){
        ++count; 
		var placeId = final[i].place_id;
		//Google API address.
		var durl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + placeId + "&key=" + mykey;
        function back (durl,i){
		https.get(durl,function(response) {
			var body ="";
			response.on('data', function(chunk) {
				body += chunk;
			})
			response.on('end', function () {
				places = JSON.parse(body);
				var results = places.result;
				final[i].address = results.formatted_address;
				final[i].numbers = results.formatted_phone_number;
				final[i].website = results.website;
				final[i].url = results.url;
				final[i].photos = results.photos;
                --count;
                if (count === 0){
                    callback(null,final);
                };	
			})
		})}
        back(durl,i);
	}   
}

/**
 * A query by id function, for returning the detailed infos for a single place only.
 */
function idQuery(theId,callback){
	var final = [];
	var durl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + theId + "&key=" + mykey;
    function back (durl){
		https.get(durl,function(response) {
			var body ="";
			response.on('data', function(chunk) {
				body += chunk;
			})
			response.on('end', function () {
				var myPlace = new thePlace();
				var places = JSON.parse(body); 
				var results = places.result;
				console.log(body);
				myPlace.address = results.formatted_address;
				myPlace.numbers = results.formatted_phone_number;
				myPlace.website = results.website;
				myPlace.url = results.url;
				myPlace.photos = results.photos;
				final.push(myPlace);
                callback(final);
			})
		})
	}
    back(durl);
}   	

/* 
 * Function for connecting to MongoDB.
 * The MongoDB server is holding by Mlab service. In this
 * function, will build a connection with the server and 
 * initiate a database instance.
 */
function mlabConnect(callback){
    MongoClient.connect('mongodb://admin:fit5120@ds149700.mlab.com:49700/hospitallocs', (err, database) => {
    if (err) return console.log(err);
    mdb = database;
    console.log("MongoDB is successfully connected.");
	callback(null);
    })
}

/* 
 * Function for finding the information of 3 hospital near the 
 * given locations.
 */
function findHospital(thelocation,callback){
	// Initiating the return variables.
	var hospitalResult = [];
	var location = thelocation.split(',');
	var location1 = parseFloat(location[0]);
	var location2 = parseFloat(location[1]);
	// Use Built-in Near function for hospital queries.
	// Return only 3 results, the max distance is 10000.
	var doc = mdb.collection('hosp').find({ geometry: { $near: { $geometry: { type: "Point", coordinates: [location1,location2]},$maxDistance: 50000}}}).limit(3).each(function(err,result){
		if(result == null){
			mdb.close();
			callback(null,hospitalResult);
		}
		hospitalResult.push(result);
	});
}

/* 
 * Function for finding the information of 3 police stations
 * near the given locations.
 */
function findPolice(thelocation,callback){
	// Initiating the police station result variables.
	var policeResult = [];
	var location = thelocation.split(',');
	var location1 = parseFloat(location[0]);
	var location2 = parseFloat(location[1]);
	// Use Built-in Near function for hospital queries.
	// Return only 3 results, the max distance is 10000.
	var doc = mdb.collection('police').find({ geometry: { $near: { $geometry: { type: "Point", coordinates: [location1,location2]},$maxDistance: 50000}}}).limit(3).each(function(err,result){
		if(result == null){
			mdb.close();
			callback(null,policeResult);
		}
		policeResult.push(result);
	});
}

/* 
 * Function for finding the information of 3 GPs
 * near the given locations.
 */
function findGP(thelocation,callback){
	var GPResult = [];
	var location = thelocation.split(',');
	var location1 = parseFloat(location[0]);
	var location2 = parseFloat(location[1]);
	var doc = mdb.collection('gp').find({ geometry: { $near: { $geometry: { type: "Point", coordinates: [location1,location2]},$maxDistance: 10000}}}).limit(3).each(function(err,result){
		if(result == null){
			mdb.close();
			callback(null,GPResult);
		}
		GPResult.push(result);
	});
}

/* 
 * Function for finding the information of all GPs
 * who can speak a specific language. 
 * If the given language is Chinese, the result will 
 * combine the Mandarin and Cantonese.
 */
function findGPL(language,callback){
	var GPLResult = [];
	var doc = mdb.collection('gp').find({ language: language}).each(function(err,result){
		if(result == null){
			if(language === "Chinese"){
				var doc = mdb.collection('gp').find({language:"Cantonese"}).each(function(err,result){
					if(result == null){
						var doc = mdb.collection('gp').find({language:"Mandarin"}).each(function(err,result){
							if(result == null){
								mdb.close();
								callback(null,GPLResult);
							}else{
							GPLResult.push(result);
							}
						});
					}else{
					GPLResult.push(result);
					}
				})
			}else{
			mdb.close();
			callback(null, GPLResult);
			}
		}else{
		GPLResult.push(result);
		}
	})
}

/* 
 * Emergency API setup for accepting queries for 
 * hospitals, GPs or police stations.
 */
app.get("/emergency",function(req,res){
	// Initiating searchType parameters.
	var type = req.query.searchType;
	// Initiating location parameters.
	var location = req.query.myLocation;
	// Initiating the language parameters.
	var language = req.query.language;
	// Navigate the query to different functions.
	// Use async function to organize the workflow.
	// Use async.apply to pass parameters.
	switch(type){
		case "hospital":
		async.waterfall([mlabConnect,async.apply(findHospital,location)],function(err,result){
			console.log(result);
			res.send(result);
		});
		break;
		case "police":
		async.waterfall([mlabConnect,async.apply(findPolice,location)],function(err,result){
			res.send(result);
		});
		break;
		case "gp":
		async.waterfall([mlabConnect,async.apply(findGP,location)],function(err,result){
			res.send(result);
		});
		break;
		case "gpl":
		async.waterfall([mlabConnect,async.apply(findGPL,language)],function(err,result){
			res.send(result);
		})
		console.log("here!")
		break;
	}
})

/* 
 * Test API setup for accepting queries for 
 * food, atm, lodge, etc.
 * Use async.waterfall to organize the workflow.
 */
app.get("/test",function(req,res){
	var type = req.query.searchType;
	var location = req.query.myLocation;
	var keyword = req.query.keyword;
	async.waterfall([async.apply(basicInfo,type,location,keyword),detailedInfo],function(err, result){
		if(err){
			console.log(err);
		}
		console.log(result);
		res.send(result);
	});
});

/* 
 * Apitest API setup for test the connecting avaliability.
 * Simply return a success value for successful connection.
 */
app.get("/apitest", function(req, res){
	res.send("success");
})

/* 
 * Testpy API setup for accepting parameters from client 
 * side and runs python code for generating a signiture to
 * be used in PTV query.
 */
app.get("/testpy", function(req, res){
	// Initiating parameters.
	var loc = req.query.myLocation;
	// Defining the arguments passed into python codes.
	var options = {
		args:[loc]
	};
	// Using PythonShell function to run the codes and get result.
	PythonShell.run('try.py', options, function (err,results) {
		if (err) throw err;
		res.send(results);
	});
})
app.get("/generalquery", function(req, res){
	// Initiating searchType parameters.
	var type = req.query.searchType;
	// Initiating location parameters.
	var location = req.query.myLocation;
	var keyword = req.query.keyword;
	basicInfo(type, location, keyword, function(result){
		res.send(arguments[1]);
	})
})
app.get("/detailedquery", function(req, res){
	var theId = req.query.placeId;
	idQuery(theId, function(result){
		res.send(result);
	})
})




