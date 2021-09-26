extends Node

var __shaders: Dictionary = {}
var __shader_resources: String = 'res://spyderlib/autoload/shader_resources/'

func _ready():
	var __directory: Directory = Directory.new()
	__directory.open(__shader_resources)
	__directory.list_dir_begin()
	
	while true:
		var __file = __directory.get_next()
		if __file == '':
			break
		elif not __file.begins_with('.'):
			var __shader: Shader = load(__shader_resources + __file)
			var __shader_name: String = __file.split('.')[0]
			__shaders[__shader_name] = __shader

# You can't seem to allocate materials from within this file.
# You have to generate the material, pass it back, then let the caller do the assignment.
func get_shader_material(_shader_name: String):
	if __shaders.has(_shader_name):
		var __shader_material: ShaderMaterial = ShaderMaterial.new()
		__shader_material.shader = __shaders[_shader_name]
		return __shader_material

func get_shader_param(_object: Node2D, _param_name: String):
	if _object and _object.material and _object.material.shader:
		var __param = _object.material.get_shader_param(_param_name)
		return __param
	return null

func set_shader_param(_object: Node2D, _param_name: String, _value) -> void:
	if _object and _object.material and _object.material.shader:
		if _object.material.get_shader_param(_param_name) != null:
			_object.material.set_shader_param(_param_name, _value)


# VHS
# Glitch
# 
