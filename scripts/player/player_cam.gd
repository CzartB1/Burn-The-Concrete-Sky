class_name  Cam_Holder
extends Node3D

@export var master: Player
@export var cam: Camera3D
@export var body:Node3D
var ray_origin = Vector3()
var ray_target = Vector3()
var mousepos


func _process(delta):
	if master.alive and !master.in_dialogue:
		if master.controller:
			var cam_pos=body.global_position.lerp(master.cont_look_target.global_position,.2)
			position = position.lerp(cam_pos, delta*10)
		elif !master.controller:
			mousepos = get_viewport().get_mouse_position()
			ray_origin = cam.project_ray_origin(mousepos)
			ray_target = ray_origin + cam.project_ray_normal(mousepos) * 2000
			var space_state = get_world_3d().direct_space_state
			var params = PhysicsRayQueryParameters3D.new()
			params.from = ray_origin + Vector3.UP
			params.to = ray_target
			params.exclude = []
			var intersection = space_state.intersect_ray(params)
			#if not intersection.is_empty():
				#var pos = Vector3(intersection.position.x, global_position.y,intersection.position.z)
				#var cam_pos=body.global_position.lerp(pos,.4)
				#position = position.lerp(cam_pos, delta*10)
			var pos = Vector3(intersection.position.x, global_position.y,intersection.position.z)
			var cam_pos=body.global_position.lerp(pos,.4)
			position = position.lerp(cam_pos, delta*10)
	elif !master.alive or master.in_dialogue:
		position = body.global_position #TODO make player move with ragdoll or force after death to make it look more dynamic

func reset_cam_position():
	position=body.global_position
