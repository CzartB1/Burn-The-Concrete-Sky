extends Area3D

@export var push_direction: Vector3 = Vector3(1, 0, 0)  # Direction the belt moves.
@export var push_speed: float = 5                     # The constant speed along the belt.
@export var remove_push_on_exit: bool = true          # Restore the object's original velocity on exit?

var bodies_in_area: Array[CharacterBody3D] = []
var original_velocity: Dictionary = {}  # Stores each body's velocity at entry.


func _on_body_entered(body: Node) -> void:
	if body is CharacterBody3D:
		bodies_in_area.append(body)
		# Optionally store the original velocity so it can be restored later.
		if remove_push_on_exit:
			original_velocity[body] = body.velocity

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody3D:
		bodies_in_area.erase(body)
		# If desired, revert the belt's effect immediately.
		if remove_push_on_exit and original_velocity.has(body):
			body.velocity = original_velocity[body]
			original_velocity.erase(body)

func _physics_process(delta: float) -> void:
	for body in bodies_in_area:
		if body is Enemy:
			# Preserve vertical motion (e.g. gravity) while overriding horizontal movement.
			var current_vel: Vector3 = body.velocity
			var horizontal_velocity: Vector3 = push_direction.normalized() * push_speed
			# Assuming the conveyor is horizontal; if push_direction has vertical components,
			# you may need to adjust what parts of the velocity to preserve.
			body.velocity = original_velocity[body]+horizontal_velocity + Vector3(0, current_vel.y, 0)
		elif body is Player:
			# Preserve vertical motion (e.g. gravity) while overriding horizontal movement.
			var current_vel: Vector3 = body.velocity
			var horizontal_velocity: Vector3 = push_direction.normalized() * push_speed
			# Assuming the conveyor is horizontal; if push_direction has vertical components,
			# you may need to adjust what parts of the velocity to preserve.
			body.external_velocity = horizontal_velocity + Vector3(0, current_vel.y, 0)
