extends Node3D

func _ready():
	randomize()  # Seed the RNG for varied results
	for child in get_children():
		# Recursively search for an AnimationPlayer node in the child
		var anim_player = child.find_child("AnimationPlayer", true, false)
		if anim_player:
			play_random_animation(anim_player)
		child.global_position.z+=randf_range(-1,1)

func play_random_animation(anim_player: AnimationPlayer):
	var animations = anim_player.get_animation_list()
	if animations.size() > 0:
		var random_index = randi() % animations.size()
		anim_player.play(animations[random_index])
