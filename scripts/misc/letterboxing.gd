class_name Letterbox
extends CanvasLayer

@export var show_box:bool=false

func _ready():
	$ColorRect.position=Vector2(0,-128)
	$ColorRect2.position=Vector2(0,648)
	visible=true

func _process(delta):
	var top_tween=create_tween()
	var bottom_tween=create_tween()
	if!show_box:
		top_tween.tween_property($ColorRect,"position",Vector2(0,-128),.5*Engine.time_scale)
		bottom_tween.tween_property($ColorRect2,"position",Vector2(0,648),.5*Engine.time_scale)
	elif show_box:
		top_tween.tween_property($ColorRect,"position",Vector2(0,-64),.5*Engine.time_scale)
		bottom_tween.tween_property($ColorRect2,"position",Vector2(0,616),.5*Engine.time_scale)
