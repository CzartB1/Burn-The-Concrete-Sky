extends Node3D

@export var character_controller: CharacterBody3D  # Reference to the player/controller
@export var raycast_node: RayCast3D  # RayCast3D to detect surfaces
@export var footstep_interval: float = 0.5  # Time between footsteps
@export var audio_player:AudioStreamPlayer3D

# Array of footstep sounds (one for each surface type)
@export var material_groups: Array = ["dirt", "metal", "wood"]
@export var footstep_sounds: Array[AudioStream] = []
@export var default_footstep_sound: AudioStream

# Timer to control footstep intervals
var time_since_last_step: float = 0.0

func _physics_process(delta: float):
	# Ensure the controller and raycast are set
	if !character_controller or !raycast_node:
		return

	# Check if the character is moving and on the ground
	if character_controller.is_on_floor() and character_controller.velocity.length() > 1.0:
		time_since_last_step += delta
		if time_since_last_step >= footstep_interval:
			play_footstep()
			time_since_last_step = 0.0

func play_footstep():
	# Use RayCast3D to detect the surface material
	if raycast_node.is_colliding():
		var collider = raycast_node.get_collider()
		var group_index: int = -1

		# Check which group the collider belongs to
		for i in range(material_groups.size()):
			if collider.is_in_group(material_groups[i]):
				group_index = i
				break
		# DEBUG: Print detected group and index
		#print("Group Index Found:", group_index, "Group Name:", material_groups[group_index])
		# Determine the appropriate sound
		var sound: AudioStream = default_footstep_sound
		if group_index >= 0 and group_index < footstep_sounds.size():
			sound = footstep_sounds[group_index]
		
		# Play the sound
		if sound:
			audio_player.stream = sound
			audio_player.play()
			# Automatically remove the node after playback
			#print("step")
