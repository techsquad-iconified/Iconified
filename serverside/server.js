const express = require("express");
const bodyParser = require("body-parser");
const https = require("https");
const async = require("async");
const app = express();

var db;

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
	var purl ="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="+ alocation +"&types="+atype + "&rankby=distance" + "&key="+g1key;
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
		var durl = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + placeId + "&key=" + g1key;
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


