extends Player_Ability

@export var anchor_object: PackedScene
@export var body: Node3D
@export var spread=25.0
@export_group("cooldown")
@export var cooldown_timer:Timer
@export var cooldown_time_max:float=100
var cooldown_time:float
@export var cooldown_bar: ProgressBar
var spawned=false
var anchor
var cooldown=false
var anchored=false

func _ready():
	cooldown_time=cooldown_time_max
	cooldown_bar.max_value=cooldown_time_max
	cooldown_bar.value=cooldown_time

func _process(delta):
	super._process(delta)
	cooldownBarVisibility()
	cooldown_bar.max_value=cooldown_time_max
	cooldown_bar.value=cooldown_time
	if cooldown_time<cooldown_time_max: cooldown_time+=delta*10

func Ability():
	if cooldown_time>=cooldown_time_max and !anchored:
		anchor = anchor_object.instantiate()
		get_tree().get_root().add_child(anchor)
		anchor.global_position = global_position
		anchored=true
	else:
		if anchored: teleport()
	#TODO tp to anchor when pressed after placing anchor

func cooldownBarVisibility():
	if cooldown_time>=cooldown_time_max: # FULL
		cooldown_bar.visible=false
	elif cooldown_time<=cooldown_time_max: # NOT FULL
		cooldown_bar.visible=true

func teleport():
	if anchor!=null:
		plr.global_position=anchor.global_position
		cooldown_time=0
		anchored=false
		anchor.queue_free()
