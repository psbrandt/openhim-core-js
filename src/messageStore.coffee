

http = require 'http'
mongo = require 'mongodb'
config = require '../config'

server = new mongo.Server LOCATION,PORT,native_parse:true
db = new mongo.Db DATABASE_NAME, server  
db.open (error, connection) ->
  console.log "Connected to #{DATABASE_NAME}"

exports.storeRequest = (req, res, next) ->	
	collection = db.collection "transaction"
	request = {
	      path:req.path,
	      headers:[JSON.stringify(req.headers)],
	      requestParams:[JSON.stringify(req.query)],
	      body:JSON.stringify(req.body),
	      method:req.method,
	      timestamp:new Date().getTime()
	    }	
	collection.insert(
	 {
	  transactionId: req.param('transactionId'),
	  status: req.param('status'),
	  applicationId: req.param('applicationId'),
	  request:request
	  response:{},
	  routes:[req.route],
	  orchestrations:[{
	      name:req.orchestrationName,
	      request:request,
	      response:{}
	    }],
	  properties:[JSON.stringify(req.properties)]
	 }
	)
	console.log "store request"
	next()

exports.storeResponse = (req, res, next) ->
	response = {
	      status:res.statusCode,
	      body:JSON.stringify(res.body),
	      headers:[JSON.stringify(res.headers)],
	      timestamp:new Date().getTime()
	    }
	collection = db.collection("transaction")
	collection.update(
	    {transactionId: req.body.transactionId},
	    {$set: {response:response}}
	)
	next()

