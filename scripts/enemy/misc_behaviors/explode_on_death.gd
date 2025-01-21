extends Node3D

@export var master:Enemy
@export var explosion:PackedScene

func _process(delta):
	if master.hp<=0:
		var instance = explosion.instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = master.global_position
