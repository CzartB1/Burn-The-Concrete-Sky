extends Upgrade

var spawned_blades=false
@export var blade: PackedScene

func _ready():
	pass # Replace with function body.

func _process(delta):
	if enabled:
		if manager.player.dashing and !spawned_blades:
			print("dash")
			var instance = blade.instantiate()
			get_tree().get_root().add_child(instance)
			instance.global_position = manager.player.body.global_position
			instance.rotation_degrees = manager.player.body.global_rotation_degrees
			spawned_blades=true
		elif !manager.player.dashing and spawned_blades:
			spawned_blades=false
