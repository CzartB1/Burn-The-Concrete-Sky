extends Area3D

@export var time_bar_pos:Control
@export var time_bar:ProgressBar
@export var hit_time_reduce:float=0.5
@export var timer: Timer
var cam:Camera3D
var plr:Player

func _ready():
	time_bar.max_value=timer.time_left

func _process(_delta):
	if cam==null:
		cam=get_viewport().get_camera_3d()
	elif cam!=null:
		time_bar_pos.set_position(cam.unproject_position(global_position))
	time_bar.value=timer.time_left

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body is Enemy_Bullet:
		if timer.time_left-hit_time_reduce > 1:
			timer.start(timer.time_left-body.damage*hit_time_reduce)
		elif timer.time_left-hit_time_reduce <= hit_time_reduce:
			timer.timeout.emit()
		body.queue_free()
