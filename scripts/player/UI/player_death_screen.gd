class_name Death_Screen
extends Control

@export var stat_screen:Control
@export var stat_canvas:CanvasLayer
@export var stat_screen_fade_speed:float=5
@export var cam_zoom_size:float=0.5
@export var cam_zoom_speed:float=0.5
@export var HUD:CanvasLayer
@onready var t:Timer=$Timer
var zoom:float
var origin_fov:float
var cam:Cam_Holder
var death_zoom=false
var start_wait
var fade_in_screen=false

func _ready():
	#stat_screen.modulate.a=0
	stat_canvas.process_mode=Node.PROCESS_MODE_DISABLED
	stat_canvas.visible=false
	stat_canvas.layer=0
	start_wait=t.wait_time
	hide()

func _process(delta):
	if cam == null:
		cam=get_tree().get_first_node_in_group("Camera")
		origin_fov=cam.cam.size
		zoom=origin_fov*cam_zoom_size
	elif cam!=null:
		clamp(cam.cam.size,0,origin_fov)
		if cam.cam.size > zoom and death_zoom:
			cam.cam.size=zoom
	if fade_in_screen:
		#stat_screen.modulate.a+=(delta*stat_screen_fade_speed)/Engine.time_scale
		stat_screen.show_anim()
		fade_in_screen=false

func activate():
	visible=true
	show()
	if HUD and HUD.visible: HUD.visible=false
	t.start(t.wait_time*Engine.time_scale)
	stat_canvas.process_mode=Node.PROCESS_MODE_INHERIT
	stat_canvas.visible=true
	stat_canvas.layer=5
	death_zoom=true
	#TODO add black box on top and bottom of screen like in movies and otxo clear

func _on_timer_timeout():
	t.wait_time=start_wait
	fade_in_screen=true
	#HACK disable AI when dead for performance reasons
