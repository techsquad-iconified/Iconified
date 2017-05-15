/**
 * This is the code for preparing the MongoDB.
 * The codes are used to insert the records in the JSON
 * files into the MongoDB database.
 * 
 * Use fs package to finish file io works.
 * 
 * Author: Tiankun Lu 
 * Version: 0.1
 */

const express = require("express");
const bodyParser = require("body-parser");
const MongoClient = require("mongodb").MongoClient;
const https = require("https");
var fs = require('fs');

const app = express();

var adb;
var mdb;

app.use(bodyParser.urlencoded({extended:true}));

/*
 * This function is for building a connection with MongoDB.
 */
function mlabConnect(){
    MongoClient.connect('mongodb://admin:fit5120@ds149700.mlab.com:49700/hospitallocs', (err, database) => {
    if (err) return console.log(err);
    mdb = database;
    console.log("success");
    insertData();
    })
}

/*
 * This function is for reading the GP data from local JSON file and insert
 * it to MongoDB.
 */
function insertData(){
    var obj = JSON.parse(fs.readFileSync('C:\\Users\\Tiankun\\Downloads\\doctors2.json', 'utf8'));
    mdb.collection('gp').insertMany(obj);
}

/*
 * This function is for reading the police data from local JSON file and insert
 * it to MongoDB.
 */
function insertPolice(){
    var obj = JSON.parse(fs.readFileSync('C:\\Users\\Tiankun\\Desktop\\police.geojson', 'utf8'));
    mdb.collection('police').insertMany(obj);
}

mlabConnect();

