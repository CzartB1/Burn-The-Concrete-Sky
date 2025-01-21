extends RigidBody3D

@export var blood_splatter:PackedScene
@export var splatter_scale:Vector2=Vector2(0.5,2.25)

func _on_area_3d_body_entered(body):
	if body is Player or body is Enemy or body is Enemy_Bullet or body is Enemy_Bullet: return
	print("splat")
	var instance = blood_splatter.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position
	instance.scale*=randf_range(splatter_scale.x,splatter_scale.y)
	queue_free()
