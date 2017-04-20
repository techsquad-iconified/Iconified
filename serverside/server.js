const express = require("express");
const bodyParser = require("body-parser");
const https = require("https");
const async = require("async");
const app = express();
const MongoClient = require("mongodb").MongoClient;
var PythonShell = require('python-shell');

var mdb;

app.use(bodyParser.urlencoded({extended:true}));
app.use('/static', express.static('public'));

app.listen(3000, () => {
    console.log('listening on 3000')
})

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

function checkResu(result){
	if (result.status === "OK"){
		return true;
	}else{
		return false;
	}
}

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

function basicInfo(type,location,callback){
	var final = [];
	var atype = type;
	var alocation = location;
	var g1key = "AIzaSyBN5b3i9TepTRKXV3nH7DlIWo7Hu3Vq1TU";
	var g2key = "AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	var s1key = "AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8";
	var s2key = "AIzaSyAMW8Z_cdUbbVMMviRfe845JBj7xbKhRp4";
	var purl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+ alocation +"&types="+atype + "&rankby=distance" + "&key="+s1key;
	console.log(purl);
	https.get(purl, function(response) {
		var body ="";
		response.on('data', function(chunk) {
			body += chunk;
		})
		response.on('end', function () {
			places = JSON.parse(body);
			var results = places.results;
			for (i=0;i<10;i++){
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

function detailedInfo(final,callback){
	var g1key = "AIzaSyBN5b3i9TepTRKXV3nH7DlIWo7Hu3Vq1TU";
	var g2key = "AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	var s1key = "AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8";
	var s2key = "AIzaSyAMW8Z_cdUbbVMMviRfe845JBj7xbKhRp4";
    var count = 0;
	for (i=0;i<10;i++){
        ++count;
		var placeId = final[i].place_id;
		var durl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + placeId + "&key=" + s1key;
		console.log(durl);;
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

function mlabConnect(callback){
    MongoClient.connect('mongodb://admin:fit5120@ds149700.mlab.com:49700/hospitallocs', (err, database) => {
    if (err) return console.log(err);
    mdb = database;
    console.log("success");
	callback(null);
    })
}

function findHospital(thelocation,callback){
	var hospitalResult = [];
	var location = thelocation.split(',');
	var location1 = parseFloat(location[0]);
	var location2 = parseFloat(location[1]);
	console.log(location);
	var doc = mdb.collection('hosp').find({ geometry: { $near: { $geometry: { type: "Point", coordinates: [location1,location2]},$maxDistance: 10000}}}).limit(3).each(function(err,result){
		if(result == null){
			mdb.close();
			callback(null,hospitalResult);
		}
		hospitalResult.push(result);
	});
}

function findPolice(thelocation,callback){
	var policeResult = [];
	var location = thelocation.split(',');
	var location1 = parseFloat(location[0]);
	var location2 = parseFloat(location[1]);
	var doc = mdb.collection('police').find({ geometry: { $near: { $geometry: { type: "Point", coordinates: [location1,location2]},$maxDistance: 10000}}}).limit(3).each(function(err,result){
		if(result == null){
			mdb.close();
			callback(null,policeResult);
		}
		policeResult.push(result);
	});
}

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

app.get("/emergency",function(req,res){
	var type = req.query.searchType;
	var location = req.query.myLocation;
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

	}
})
app.get("/test",function(req,res){
	var type = req.query.searchType;
	var location = req.query.myLocation;
	async.waterfall([async.apply(basicInfo,type,location),detailedInfo],function(err, result){
		if(err){
			console.log(err);
		}
		console.log(result);
		res.send(result);
	});
	console.log("Test");
});

app.get("/apitest", function(req, res){
	res.send("test");
})

app.get("/testpy", function(req, res){
	var loc = req.query.myLocation;
	var options = {
		args:[loc]
	};
	PythonShell.run('try.py', options, function (err,results) {
		if (err) throw err;
		res.send(results);
	});
})




