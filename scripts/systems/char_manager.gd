extends Control

@export var room_manager: Room_manager
@export var characters: Array[PackedScene]
var spawned=false

func spawn_character(id:int):
	if spawned:return
	spawned=false
	var instance = characters[id].instantiate()
	add_child(instance)
	instance.global_position = Vector3.ZERO
	room_manager.check_room()
	
