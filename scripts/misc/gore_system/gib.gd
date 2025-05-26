extends RigidBody3D

func _on_area_3d_body_entered(body):
	if get_tree().get_first_node_in_group("recycling_ability").enabled and body is Player:
		body.hp+=1
		queue_free()

func _on_timer_timeout():
	queue_free()
