extends RigidBody3D

@export var attract_radius: float = 5.0 # Distance within which the money flies to the player
@export var attraction_speed: float = 65.0 # Speed at which the money moves toward the player
@export var spawn_to_fly_delay: float = 0.4
var plr: Node = null
var is_physics_disabled: bool = false # To track whether physics is disabled
var can_fly=false

func _ready():
	await get_tree().create_timer(spawn_to_fly_delay).timeout
	can_fly=true

func _process(delta):
	# Find the player
	plr = get_tree().get_first_node_in_group("Player")
	if plr == null:
		return

	# Check distance to the player
	var distance = global_transform.origin.distance_to(plr.global_transform.origin)
	if distance <= attract_radius and can_fly:
		# Disable physics and manually move toward the player
		if not is_physics_disabled:
			sleeping = true
			is_physics_disabled = true

		# Rotate to face the player
		look_at(plr.global_transform.origin, Vector3.UP)

		# Move toward the player
		var direction = (plr.global_transform.origin - global_transform.origin).normalized()
		global_transform.origin += direction * attraction_speed * delta
	else:
		# Re-enable physics when outside the radius
		if is_physics_disabled:
			sleeping = false
			is_physics_disabled = false

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		var econom = get_tree().get_first_node_in_group("Economy")
		if econom is Player_Economy_Manager:
			econom.increase_money(1)
			queue_free()
