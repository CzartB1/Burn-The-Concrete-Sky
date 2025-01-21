extends Area3D

@export var damage: int = 10

func _on_body_entered(body):
	if body is Enemy:
		body.take_damage(damage)
		queue_free()


func _on_timer_timeout():
	queue_free()
