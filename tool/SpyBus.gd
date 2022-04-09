tool
extends Node

#########
# SETUP: 
#########
# - Attach this script to any node.
# - Fill out the export variables in the editor.
# - When the project runs, the code will execute.
#########

export var bus_name: String = ""
export var bus_index: int = 1
export var bus_route: String = "Master"
export var bus_effects: Array = [] # Should be of type AudioEffect.

func _ready():
	if bus_index < AudioServer.bus_count:
		push_error("Can't add bus at index " + str(bus_index) + ". This bus already exists.")
		return
	
	AudioServer.add_bus(bus_index)
	AudioServer.set_bus_name(bus_index, bus_name)
	AudioServer.set_bus_send(bus_index, bus_route)
	
	for effect in bus_effects:
		if effect is AudioEffect:
			AudioServer.add_bus_effect(bus_index, effect)
