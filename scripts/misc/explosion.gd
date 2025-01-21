extends Area3D

@export var damage:int = 2
@export var radius:float=5
@export var disable_view:bool=true

func _ready():
	var shape = CylinderShape3D.new()
	var view = CylinderMesh.new()
	view.top_radius=radius
	view.bottom_radius=radius
	view.material=$MeshInstance3D.mesh.material
	shape.radius=radius
	$CollisionShape3D.shape = shape
	$MeshInstance3D.mesh = view
	if disable_view:$MeshInstance3D.queue_free()

func _on_body_entered(body):
	if body is Player: body.take_damage(damage)
	elif body is Enemy: body.take_damage(damage)


func _on_timer_timeout():
	queue_free()
