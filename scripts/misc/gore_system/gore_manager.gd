class_name Gore_Manager
extends Node3D

@export var blood_mist:GPUParticles3D
@export var death_effect:PackedScene
@export var blood_splatter:PackedScene
@export var gib:PackedScene
@export_group("splatter")
@export var blood_splat_force:Vector2=Vector2(.2,2)
@export var blood_splat_amount:Vector2i=Vector2(2,5)
@export var blood_splat_size:Vector2=Vector2(1,4)
@export var blood_splat_rot_mod:float=45
@export var gib_splat_amount:Vector2i=Vector2(2,4)
@export var gib_splat_force:Vector2=Vector2(1,2)
@export var gib_splat_size:Vector2=Vector2(.5,2)
@export_group("squirt")
@export var blood_squirt_force:Vector2=Vector2(1,7)
@export var blood_squirt_amount:Vector2i=Vector2(1,8)
@export var blood_squirt_size:Vector2=Vector2(0.1,0.8)
@export var blood_squirt_rot_mod:float=5

func mist_activate(attacker:Vector3):
	blood_mist.look_at(attacker)
	blood_mist.emitting=true

func activate_death_effect():
	var instance = death_effect.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position
	instance.global_rotation=global_rotation
	instance.global_rotation.y+=180
	instance.emitting=true

func shoot_splatters(attacker:Vector3):
	var am=randi_range(blood_splat_amount.x,blood_splat_amount.y)
	for i in am:
		var instance = blood_splatter.instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = global_position
		var s=randf_range(blood_splat_size.x,blood_splat_size.y)
		instance.scale=Vector3(s,s,s)#FIXME fix scaling
		instance.look_at(attacker)
		instance.global_rotation.y-=(180+randf_range(-blood_splat_rot_mod,blood_splat_rot_mod))
		instance.apply_impulse((get_parent_node_3d().transform.basis.z+Vector3(randf_range(-0.5,0.5),0,0)) * randf_range(blood_splat_force.x, blood_splat_force.y))
	var gi=randi_range(gib_splat_amount.x,gib_splat_amount.y)
	for g in gi:
		print("gib spawn")
		var gibi = gib.instantiate()
		get_tree().get_root().add_child(gibi)
		gibi.global_position = global_position
		var s=randf_range(gib_splat_size.x,gib_splat_size.y)
		gibi.scale=Vector3(s,s,s)#FIXME fix scaling
		gibi.look_at(attacker)
		gibi.global_rotation.y-=(180+randf_range(-blood_splat_rot_mod,blood_splat_rot_mod))
		gibi.apply_impulse((get_parent_node_3d().transform.basis.z+Vector3(randf_range(-0.5,0.5),0,0)) * randf_range(gib_splat_force.x, gib_splat_force.y))

func shoot_squirt(attacker:Vector3):
	var am=randi_range(blood_squirt_amount.x,blood_squirt_amount.y)
	for i in am:
		var instance = blood_splatter.instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = global_position
		instance.look_at(attacker)
		instance.global_rotation.y-=(180+randf_range(-blood_squirt_rot_mod,blood_squirt_rot_mod))
		instance.apply_impulse((get_parent_node_3d().transform.basis.z+Vector3(randf_range(-0.5,0.5),0,0)) * randf_range(blood_squirt_force.x, blood_squirt_force.y))
		instance.splatter_scale=blood_squirt_size
