const express = require("express");
const bodyParser = require("body-parser");
const https = require("https");
const async = require("async");
const app = express();

var db;

app.set('view engine','pug');
app.use(bodyParser.urlencoded({extended:true}));
app.use('/static', express.static('public'));

app.listen(3000, () => {
    console.log('listening on 3000')
})

/*
async.waterfall([basicInfo,detailedInfo],function(err, result){
    if(err){
        console.log(err);
    }
	console.log(result);
});
*/
function checkUnd(theValue){
	if(typeof(theValue) ==="undefined"){
		return "unavailable";
	}else{
		return theValue;
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
	this.opening_hours = "unavailable";
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
	var shishirakey = "AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8";
	var gkey = "AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	var purl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+ alocation +"&types="+atype + "&rankby=distance" + "&key="+shishirakey;
	https.get(purl, function(response) {
		var body ="";
		response.on('data', function(chunk) {
			body += chunk;
		})
		response.on('end', function () {
			places = JSON.parse(body);
			if(checkResu(places)){
				var results = places.results;
				for (i=0;i<10;i++){
					var myPlace = new thePlace();
					myPlace.name = results[i].name;
					myPlace.location = results[i].geometry.location;
					myPlace.opening_hours = checkUnd(results[i].opening_hours);
					myPlace.place_id = results[i].place_id;
					myPlace.price_level = results[i].price_level;
					myPlace.rating = results[i].rating;
					final.push(myPlace);
				}
			}else{
				console.log("no results");
			}
			callback(null,final);
		})
	})
}

function detailedInfo(final,callback){
    var count = 0;
	for (i=0;i<10;i++){
        ++count;
		var placeId = final[i].place_id;
		var durl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + placeId + "&key=AIzaSyCptoojRETZJtKZCTgk7Oc29Xz0i-B6cv8";
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

app.get("/api", function(req, res){
	var type = req.query.searchType;
	var location = req.query.myLocation;
	var radius = 500;
	var gkey = "AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	var furl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+location +"&types="+type + "&rankby=distance" + "&key="+gkey;
	var turl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670,151.1957&types=food&rankby=distance&key=AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	sendBack(furl,res);
})
function sendBack (url,res) {
	var foo = [];
	https.get(url, function(response) {
		var body ="";
		response.on('data', function(chunk) {
			body += chunk;
		})
		response.on('end', function () {
			places = JSON.parse(body);
			var results = places.results;
			console.log(results[0]);
			for (i=0;i<5;i++){
				foo.push(results[i].name);
				foo.push(results[i].geometry.location);
				foo.push(results[i].opening_hours);
				foo.push(results[i].place_id);
				foo.push(results[i].price_level);
				foo.push(results[i].rating);
				foo.push(results[i].vicinity);
			};
			res.send(foo);
		});
	})
}

app.get("/apitest", function(req, res){
	var type = req.query.searchType;
	var location = req.query.myLocation;
	var placeId = "here";
	var gkey = "AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	var purl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+ location +"&types="+type + "&rankby=distance" + "&key="+gkey;
	var examp ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670,151.1957&types=food&rankby=distance&key=AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	var durl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + placeId + "&key=AIzaSyDWr-XTd2CRiUhzGgaGBIYm7_HZE09hgqg";
	var foo = [];
	var thePlaceId = [];
	https.get(url, function(response) {
		var body ="";
		response.on('data', function(chunk) {
			body += chunk;
		})
		response.on('end', function () {
			places = JSON.parse(body);
			var results = places.results;
			res.send(results);
			for (i=0;i<5;i++){
				foo.push(results[i].name);
				foo.push(results[i].geometry.location);
				foo.push(results[i].opening_hours);
				thePlaceId.push(results[i].place_id);
				foo.push(results[i].price_level);
				foo.push(results[i].rating);
			}

		});
	});
	sendBackTest(purl,res);
});
function sendBackTest (url,res) {
	var foo = [];
	https.get(url, function(response) {
		var body ="";
		response.on('data', function(chunk) {
			body += chunk;
		})
		response.on('end', function () {
			places = JSON.parse(body);
			var results = places.results;
			res.send(results);
		});
	})
}



