class_name Gladiator_Hook
extends CharacterBody3D

@export var speed = 100
@export var line:Line_Renderer
@export var stun_area:PackedScene
var master: Gladiator_Ability
var returning=false

func _process(delta):
	if returning:
		look_at(master.body.global_position)

func _physics_process(_delta):
	velocity = global_transform.basis.z * -speed
	line.points[0]=master.body.global_position
	line.points[1]=global_position
	move_and_slide()

func _on_area_3d_body_entered(body):
	if !returning:
		if body != Player and body != Player_Bullet and body != Enemy_Bullet and body != self:
			if body is Enemy:
				master.pull_enemy(body)
				master.locked_in=true
				queue_free()
			elif body is CollisionObject3D:
				returning=true
	elif returning:
		if body == Player or master.body.global_position.distance_to(global_position)<=1:
			queue_free()

func _on_timer_timeout():
	returning=true
