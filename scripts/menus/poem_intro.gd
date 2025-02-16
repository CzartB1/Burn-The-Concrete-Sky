class_name PoemIntro
extends CanvasLayer

@export var fade_duration: float = 1.0
@export var delay_between_labels: float = 0.5
@export var labels: Array[RichTextLabel]
@export var delay_before_fade_out: float = 1.0
@export var fade_out_duration: float = 1.0
@export var skip_fade_out_duration: float = 0.5
@export var control_to_fade_out: Control

var skip_fade := false
var fade_out_started := false
var current_tween: Tween = null
var intro_finished=false

func _ready() -> void:
	for label in labels:
		label.modulate.a = 0.0
	if control_to_fade_out:
		control_to_fade_out.modulate.a = 1.0
	fade_labels_in_sequence()

func _input(event: InputEvent) -> void:
	# Ignore input if fade-out is already in progress.
	if fade_out_started:
		return
	if (event is InputEventKey and event.pressed) or (event is InputEventMouseButton and event.pressed):
		skipFade()

func fade_labels_in_sequence() -> void:
	for label in labels:
		if skip_fade:
			break
		current_tween = get_tree().create_tween()
		current_tween.tween_property(label, "modulate:a", 1.0, fade_duration)
		await current_tween.finished
		if skip_fade:
			break
		await get_tree().create_timer(delay_between_labels).timeout

	# Ensure all labels are fully visible.
	for label in labels:
		label.modulate.a = 1.0

	if not skip_fade:
		await get_tree().create_timer(delay_before_fade_out).timeout
	startFadeOut()

func startFadeOut(custom_duration: float = -1.0) -> void:
	if fade_out_started:
		return
	fade_out_started = true

	var duration: float
	if custom_duration >= 0:
		duration = custom_duration
	else:
		duration = fade_out_duration

	current_tween = get_tree().create_tween()
	current_tween.tween_property(control_to_fade_out, "modulate:a", 0.0, duration)
	await current_tween.finished
	intro_finished=true

func skipFade() -> void:
	if skip_fade or fade_out_started:
		return
	skip_fade = true
	for label in labels:
		label.modulate.a = 1.0
	if current_tween:
		current_tween.kill()
	startFadeOut(skip_fade_out_duration)
