class_name Gore_Manager
extends Node3D

@export var blood_mist:GPUParticles3D
@export var death_effect:PackedScene
@export var blood_splatter:PackedScene
@export var blood_splat_force:Vector2=Vector2(4,12)
@export var blood_splat_amount:Vector2i=Vector2(2,5)

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
		instance.look_at(attacker)
		instance.global_rotation.y-=180
		instance.apply_impulse((get_parent_node_3d().transform.basis.z+Vector3(randf_range(-0.5,0.5),0,0)) * randf_range(blood_splat_force.x, blood_splat_force.y))
