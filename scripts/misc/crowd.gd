extends Node3D

@export var use_variant_randomization: bool = false
@export var variant_prefix: String = "variant_"

func _ready():
	randomize()  # Seed the RNG for varied results
	for child in get_children():
		var target_node: Node = child
		if use_variant_randomization:
			var variant_nodes: Array = []
			# Check immediate children for nodes with the specified prefix
			for sub in child.get_children():
				if sub.name.begins_with(variant_prefix):
					variant_nodes.append(sub)
			if variant_nodes.size() > 0:
				# Choose one variant at random
				var random_index = randi() % variant_nodes.size()
				target_node = variant_nodes[random_index]
				# Hide all variants except the selected one
				for variant in variant_nodes:
					variant.visible = false
				target_node.visible = true
		# Find an AnimationPlayer anywhere in the target node's hierarchy
		var anim_player = target_node.find_child("AnimationPlayer", true, false)
		if anim_player:
			play_random_animation(anim_player)

func play_random_animation(anim_player: AnimationPlayer):
	var animations = anim_player.get_animation_list()
	if animations.size() > 0:
		var random_index = randi() % animations.size()
		anim_player.play(animations[random_index])
