class_name Room_End
extends Area3D

@export var room:Room
@export var intro=false
var can_go=false

func _ready():
	if room == null: 
		printerr("The room end in "+ get_parent_node_3d().name+" havent recognized their room. Just fix it real quick, will ya?")
		push_error("The room end in "+ get_parent_node_3d().name+" havent recognized their room. Just fix it real quick, will ya?")
	

func _process(delta):
	if room!=null:
		room.end=self
		if room.manager!=null and room.manager.current_room_category!=1:can_go=true
		elif room.manager!=null and room.manager.current_room_category==1:
			can_go=true

func _on_body_entered(body):
	if body is Player and room.process_mode == Node.PROCESS_MODE_INHERIT and can_go and (!room.manager.can_change or intro):
		#await get_tree().physics_frame
		#print("asdf")
		body.dashing=false
		room.manager.can_change=true
		intro=false
		room.change_level()
