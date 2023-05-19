extends Node2D

onready var __getter: HTTPRequest = HTTPRequest.new()
onready var __poster: HTTPRequest = HTTPRequest.new()
onready var __patcher: HTTPRequest = HTTPRequest.new()
onready var __deleter: HTTPRequest = HTTPRequest.new()

signal get_callback
signal post_callback
signal patch_callback
signal delete_callback

var base_address: String = "" setget set_base_address
func set_base_address(_base_address):
	base_address = _base_address

func _ready():
	add_child(__getter)
	add_child(__poster)
	add_child(__patcher)
	add_child(__deleter)
	__getter.connect("request_completed", self, "_get_request_completed")
	__poster.connect("request_completed", self, "_post_request_completed")
	__patcher.connect("request_completed", self, "_patch_request_completed")
	__deleter.connect("request_completed", self, "_delete_request_completed")

func GET(_endpoint):
	__getter.request(base_address + _endpoint, [], true, HTTPClient.METHOD_GET)

func _get_request_completed(_result, _response_code, _headers, _body):
	var _dict: Dictionary = {}
	if _result == HTTPRequest.RESULT_SUCCESS and _response_code >= 200 and _response_code < 300:
		var _response_str: String = _body.get_string_from_utf8()
		if OS.get_name() == "HTML5":
			_response_str = _jsonp_to_json(_response_str)
		_dict = parse_json(_response_str)
	emit_signal("get_callback", _response_code, _dict)

func POST(_endpoint, _payload):
	__poster.request(base_address + _endpoint, [], true, HTTPClient.METHOD_POST, _payload)

func _post_request_completed(_result, _response_code, _headers, _body):
	emit_signal("post_callback", _result == HTTPRequest.RESULT_SUCCESS and _response_code >= 200 and _response_code < 300)

func PATCH(_endpoint, _payload):
	__patcher.request(base_address + _endpoint, [], true, HTTPClient.METHOD_PATCH, _payload)

func _patch_request_completed(_result, _response_code, _headers, _body):
	emit_signal("patch_callback", _result == HTTPRequest.RESULT_SUCCESS and _response_code >= 200 and _response_code < 300)

func DELETE(_endpoint):
	__patcher.request(base_address + _endpoint, [], true, HTTPClient.METHOD_DELETE)

func _delete_request_completed(_result, _response_code, _headers, _body):
	emit_signal("delete_callback", _result == HTTPRequest.RESULT_SUCCESS and _response_code >= 200 and _response_code < 300)

func _jsonp_to_json(_jsonp):
	var obj_start = "var jsonp = "
	var _json = _jsonp.substr(obj_start.length(), _jsonp.length() - obj_start.length())
	return _json
