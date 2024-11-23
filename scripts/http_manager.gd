extends Node
class_name HTTPManager

var url = "http://localhost:8080"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func postReq(path, data={}, params={}):
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	var reqNode = HTTPRequest.new()
	add_child(reqNode)
	
	var first = true
		
	for key in params.keys():
		if first:
			path += "?"
			first = false
		else:
			path += "&"
		path += key + "=" + str(params[key]).replace(" ", "%20")
		
	var error = reqNode.request(url + path, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		reqNode.queue_free()
		return false
		
	var response = await reqNode.request_completed

	var result = response[0]
	var response_code = response[1]
	var response_headers = response[2]
	
	reqNode.queue_free()
	
	if(result != HTTPRequest.RESULT_SUCCESS || response_code < 200 || response_code > 299):
		print(path)
		print(response)
		return false
	
	var body = JSON.parse_string(response[3].get_string_from_utf8())
		
	if(body == null):
		return true
	
	return body

func putReq(path, data={}, params={}):
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	var reqNode = HTTPRequest.new()
	add_child(reqNode)
	
	var first = true
		
	for key in params.keys():
		if first:
			path += "?"
			first = false
		else:
			path += "&"
		path += key + "=" + str(params[key]).replace(" ", "%20")
		
	var error = reqNode.request(url + path, headers, HTTPClient.METHOD_PUT, json)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		reqNode.queue_free()
		return false
		
	var response = await reqNode.request_completed

	var result = response[0]
	var response_code = response[1]
	var response_headers = response[2]
	
	reqNode.queue_free()
	
	if(result != HTTPRequest.RESULT_SUCCESS || response_code < 200 || response_code > 299):
		print(path)
		print(response)
		return false
	
	
	var body = JSON.parse_string(response[3].get_string_from_utf8())
		
	if(body == null):
		return true
	
	return body
	
func getReq(path, params={}):
	var reqNode = HTTPRequest.new()
	add_child(reqNode)
	
	var first = true
		
	for key in params.keys():
		if first:
			path += "?"
			first = false
		else:
			path += "&"
		path += key + "=" + str(params[key]).replace(" ", "%20")
	
	var error = reqNode.request(url + path, [], HTTPClient.METHOD_GET)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		reqNode.queue_free()
		return false
	
	var response = await reqNode.request_completed
	
	var result = response[0]
	var response_code = response[1]
	var response_headers = response[2]
	var body = JSON.parse_string(response[3].get_string_from_utf8())
	
	reqNode.queue_free()
	
	if(result != HTTPRequest.RESULT_SUCCESS || response_code < 200 || response_code > 299):
		print(path)
		print(response)
		return false
		
	if(body == null):
		return true
	
	return body

	
