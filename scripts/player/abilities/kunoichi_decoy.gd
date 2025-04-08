class_name Kunoichi_Decoy
extends CharacterBody3D

var enemies: Array
@export var stun_area:PackedScene
@export var timer:Timer

#func _ready():
	#spawn_stun()

func _process(delta):
	enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if enemy is Enemy:
			enemy.distraction=self

func _on_timer_timeout():
	dead()

func spawn_stun():
	var instance = stun_area.instantiate()
	add_child(instance)
	instance.global_position = global_position

func damage(damage:int=1):
	if timer.time_left>1:
		timer.start(timer.time_left-(damage/5))
	elif timer.time_left<=1:
		dead()

func dead():
	if enemies==null:
		enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if enemy is Enemy:
			enemy.distraction=null
	#var instance = stun_area.instantiate()
	#get_tree().get_root().add_child(instance)
	#instance.global_position = global_position
	queue_free()


func _on_area_3d_body_entered(body):
	if body is Enemy_Bullet:
		damage(body.damage)
		body.queue_free()
