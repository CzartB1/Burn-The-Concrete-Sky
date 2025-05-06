extends Control

@export var scroll_speed: float = 50.0        # Pixels per second for scrolling
@export var top_pos: float = -485.0        # Start offset below screen
@export var bottom_pos: float = 648.0     # End offset above screen
@export var fade_duration: float = 2.0       # Seconds for fade-out
@export var start_scrolling: bool = false    # Toggle to begin credits

@onready var credits_container: VBoxContainer = $VBoxContainer
@onready var screen_size: Vector2 = get_viewport().get_visible_rect().size

var fading: bool = false
var fade_timer: float = 0.0

func _ready():
	restart_pos()

func _process(delta: float) -> void:
	# Only scroll/fade when triggered
	if !start_scrolling:
		return

	if !fading:
		# Scroll credits upward
		credits_container.position.y -= scroll_speed * delta
		# If fully scrolled past, begin fade-out
		if credits_container.position.y < top_pos:
			fading = true
			fade_timer = fade_duration
	else:
		# Fade out by reducing alpha over time
		fade_timer -= delta
		modulate.a = clamp(fade_timer / fade_duration, 0.0, 1.0)
		# Once fully faded, disable and reset trigger
		if fade_timer <= 0.0:
			visible = false
			start_scrolling = false
			process_mode=Node.PROCESS_MODE_DISABLED

func restart_pos():
	process_mode=Node.PROCESS_MODE_INHERIT
	visible=true
	modulate.a = 1.0
	fading=false
	credits_container.position.y=bottom_pos
