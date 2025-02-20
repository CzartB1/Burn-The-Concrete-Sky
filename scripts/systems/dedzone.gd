extends Area3D

func _on_body_entered(body):
	print(body.name+" fell to the dedzone")
	if body is Enemy: body.take_damage(999999999)
	elif body is Player:body.take_damage(9999999)
