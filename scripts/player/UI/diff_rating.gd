# DifficultyRatingUI.gd
# A reusable HBoxContainer control showing a difficulty rating (0 to max_stars) as star icons + descriptive RichTextLabel.
# Usage:
# 1. Create a new HBoxContainer scene and add a RichTextLabel child for descriptions.
# 2. Attach this script to the HBoxContainer.
# 3. In Inspector:
#    • Assign "filled_texture" and "empty_texture" (Texture2D assets).
#    • Customize "descriptors" array labels.
#    • Drag your RichTextLabel node into "diff_description".
# 4. Call `update_rating(value)` to set difficulty.

extends HBoxContainer

# --- Configuration ---
@export var max_stars: int = 5
@export var filled_texture: Texture2D
@export var empty_texture: Texture2D
@export var descriptors: Array[String] = ["Very Easy", "Easy", "Normal", "Hard", "Expert"]
# Reference to a RichTextLabel node for displaying the descriptor
@export var diff_description: RichTextLabel

# Current rating (0 = none, 1..max_stars)
var rating: int = 0

func _ready():
	if descriptors.size() != max_stars:
		push_warning("`descriptors` length (" + str(descriptors.size()) + ") does not match `max_stars` (" + str(max_stars) + ").")
	if diff_description == null:
		push_warning("`diff_description` is not assigned. Descriptor text will not show.")
	_update_stars()

func update_rating(value: int) -> void:
	rating = clamp(value, 0, max_stars)
	_update_stars()

func _update_stars() -> void:
	# Clear previous star icons
	for child in get_children():
		if child is TextureRect:
			child.queue_free()

	# Add star icons
	for i in range(max_stars):
		var icon = TextureRect.new()
		if i < rating:
			icon.texture = filled_texture
		else:
			icon.texture = empty_texture
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(16, 16)
		add_child(icon)

	# Update descriptor text
	if diff_description:
		diff_description.clear()  # Remove previous text
		if rating > 0 and rating <= descriptors.size():
			diff_description.append_text(descriptors[rating - 1])

# Example runtime call:
# $DifficultyRating.update_rating(character.difficulty)
