extends Control

@onready var t = $Timer
var zoom:float
var origin_fov:float
var cam:Cam_Holder
var wait=false
var start_wait

func _ready():
	modulate.a=0
	start_wait=t.wait_time

func _process(delta):
	if cam == null:
		cam=get_tree().get_first_node_in_group("Camera")
		origin_fov=cam.cam.size
		zoom=origin_fov*0.85
	elif cam!=null:
		clamp(cam.cam.size,0,origin_fov)
		if cam.cam.size < origin_fov and!wait:
			cam.cam.size+=delta*5
		elif cam.cam.size > zoom and wait:
			cam.cam.size-=(delta*20)/Engine.time_scale
	if modulate.a>0 and!wait:
		modulate.a-=delta*5

func clear():
	visible=true
	modulate.a=1
	Engine.time_scale=0.2
	#cam.cam.size=zoom
	wait=true
	t.start(t.wait_time*Engine.time_scale)

func _on_timer_timeout():
	wait=false
	t.wait_time=start_wait
	Engine.time_scale=1
