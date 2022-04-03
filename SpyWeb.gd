extends Node2D

onready var __getter: HTTPRequest = HTTPRequest.new()
onready var __poster: HTTPRequest = HTTPRequest.new()
var public_url: String = "" setget set_public_url
func set_public_url(_url):
	public_url = _url
var private_url: String = ""setget set_private_url
func set_private_url(_url):
	private_url = _url
signal get_callback
signal post_callback

func _ready():
	add_child(__getter)
	add_child(__poster)
	__getter.connect("request_completed", self, "_get_request_completed")
	__poster.connect("request_completed", self, "_post_request_completed")

func GET():
	__getter.request(public_url, [])

func _get_request_completed(_result, _response_code, _headers, _body):
	if _result == HTTPRequest.RESULT_SUCCESS and _response_code == 200:
		var _response_str: String = _body.get_string_from_utf8()
		if OS.get_name() == "HTML5":
			_response_str = _jsonp_to_json(_response_str)
		var _json: Dictionary = parse_json(_response_str)
		emit_signal("get_callback", _json)
	else:
		emit_signal("get_callback", {})

func POST(_data):
	var _full_url: String =  ""
	if OS.get_name() == "HTML5":
		_full_url = private_url + "&name=" + _data.name + "&score=" + str(_data.score)
	else:
		_full_url = private_url + "/" + _data.name + "/" + str(_data.score)
	__poster.request(_full_url, [])

func _post_request_completed(_result, _response_code, _headers, _body):
	if _result == HTTPRequest.RESULT_SUCCESS and _response_code == 200:
		emit_signal("post_callback", true)
	else:
		emit_signal("post_callback", false)

func _jsonp_to_json(_jsonp):
	var obj_start = "var jsonp = "
	var _json = _jsonp.substr(obj_start.length(), _jsonp.length() - obj_start.length())
	return _json
