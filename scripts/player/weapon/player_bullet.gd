class_name Player_Bullet
extends CharacterBody3D

@export var speed = 100
@export var destroyTimer: Timer
@export var wall_particle:PackedScene
var damage = 1

func _physics_process(_delta):
	velocity = global_transform.basis.z * -speed
	move_and_slide()

func _on_timer_timeout():
	queue_free()

func _on_area_3d_body_entered(body):
	if body==self:return
	if body != Player and body != Player_Bullet:
		if body is Enemy:
			body.take_damage(damage,global_position)
		if body is Enemy_Bullet:
			print("Wowzie! You just hit a bullet!!!")
			body.queue_free()
		else:
			var instance = wall_particle.instantiate()
			get_tree().get_root().add_child(instance)
			instance.global_position = global_position
			instance.look_at(get_tree().get_first_node_in_group("Player").global_position)
			instance.global_rotation.y+=180
			instance.emitting=true
		#print(str(body.name))
		queue_free()
