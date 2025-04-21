# DifficultyRatingUI.gd
# A reusable HBoxContainer-based control that displays a difficulty rating (0 to max_stars) as a row of images.
# Usage:
# 1. Create a new scene with a root node of type HBoxContainer.
# 2. Attach this script to the HBoxContainer.
# 3. In the Inspector, assign your "filled" and "empty" star (or other icon) textures.
# 4. Set the `rating` property per-character (either in Inspector or at runtime via code).

extends HBoxContainer

# Maximum number of stars/icons to display
@export var max_stars: int = 5

# Textures for filled (active) and empty (inactive) icons
@export var filled_texture: Texture2D
@export var empty_texture: Texture2D

var rating: int = 0

func _ready():
	_update_stars()

func set_rating(value: int) -> void:
	rating = clamp(value, 0, max_stars)
	_update_stars()

func update_rating(value: int) -> void:
	set_rating(value)

func _update_stars() -> void:
	# Remove existing icons
	for child in get_children():
		child.queue_free()

	# Add icons based on current rating
	for i in range(max_stars):
		var icon = TextureRect.new()
		if i < rating:
			icon.texture = filled_texture
		else:
			icon.texture = empty_texture
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(icon)

# At runtime you can update the rating for different characters:
# $DifficultyRating.update_rating(some_character.difficulty)
