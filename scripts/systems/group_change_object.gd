extends Area3D

var plr_in=false
var manager:Room_manager
@export var destination:Combat_Group
@export var room:Room

func _process(_delta):
	if manager==null:
		manager=get_tree().get_first_node_in_group("room_manager")
	
	if plr_in and Input.is_action_just_pressed("interact"):
		manager.combatgroup.activate_group(destination)
		room.change_level()

func _on_body_entered(body):
	if body is Player and room.process_mode == Node.PROCESS_MODE_INHERIT:plr_in=true

func _on_body_exited(body):
	if body is Player:plr_in=false
