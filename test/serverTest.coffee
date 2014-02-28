should = require "should"
sinon = require "sinon"
http = require "http"
MongoClient =  require ('mongodb').MongoClient

server = require "../lib/server"
config = require "../config"


describe "OpenHIM server", ->
	it "should start the http server", ->
		server.start 5000

		http.get "http://localhost:5000/", (res) ->
			res.status.should.be.exactly 200

	it.skip "should start the https server", ->
		server.start null, 5001

describe "storeRequest", ->
 before, (done) ->
    MongoClient.connect "mongodb://"+LOCATION+":"+PORT+"/"+DATABASE_NAME, (err,db) ->
    done()
    ##server = new mongo.Server LOCATION,PORT,native_parse:true
    ##db = new mongo.Db DATABASE_NAME, server  
    ##db.open (error, connection) ->
    ##  console.log "Connected to #{DATABASE_NAME}"

  it "should save a request in the database", (done)->
      collection = db.collection "transaction"
      request = {
	      path:"/api/get/save",
	      headers:["header1":"value1"],
	      requestParams:["name":"name-value"],
	      body:{"transactioId":"88928438232"},
	      method:"POST",
	      timestamp:"894892389298392"
	    }	
	collection.insert(
	 {
	  transactionId: "88928438232",
	  status: "Processing",
	  applicationId: "Open_SINK_908932",
	  request:request
	  response:{},
	  routes:[req.route],
	  orchestrations:[{
	      name:"orchestrationName",
	      request:request,
	      response:{}
	    }],
	  properties:[{"property1":"propertyValue1"},{"property2":"propertyValue2"}]
	 },
	  (doc)
	)
