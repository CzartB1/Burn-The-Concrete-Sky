class_name Enemy_Bullet
extends CharacterBody3D

@export var speed = 100
@export var damage = 1
@export var homing:bool=false
var deflected = false

func _physics_process(_delta):
	if !deflected: velocity = global_transform.basis.z * -speed
	elif deflected: velocity = global_transform.basis.z * speed
	
	if homing:
		var plr=get_tree().get_first_node_in_group("Player")
		if plr: look_at(plr.global_position)
#	#TODO make it so that some bullets can be shot down
	move_and_slide()

func _on_timer_timeout():
	queue_free()

func _on_area_3d_body_entered(body):
	if body is Player_Bullet:
		queue_free()
	if !deflected:
		if body != Enemy and body != self and body != Enemy_Bullet:
			if body is Player and !body.dashing:
				body.take_damage(damage)
			if body is Kunoichi_Decoy:
				body.damage()
			queue_free()
	elif deflected:
		if body != Player and body != self and body != Enemy_Bullet:
			if body is Enemy:
				body.take_damage(damage, global_position)
			queue_free()
	

func deflect():
	damage*=2
	var econom=get_tree().get_first_node_in_group("Economy")
	if econom is Player_Economy_Manager:
		econom.increase_mult(.5)
	deflected = true
