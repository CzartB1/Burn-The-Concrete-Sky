class_name Player_Bullet
extends CharacterBody3D

@export var speed = 100
@export var destroyTimer: Timer
var damage = 1

func _physics_process(_delta):
	velocity = global_transform.basis.z * -speed
	move_and_slide()

func _on_timer_timeout():
	queue_free()

func _on_area_3d_body_entered(body):
	if body != Player and body != Player_Bullet and body != Enemy_Bullet and body != self:
		if body is Enemy:
			body.take_damage(damage,global_position)
		if body is enemy_shield:
			print("shield")
			body.take_damage(damage,global_position)
		print(str(body.name))
		queue_free()
