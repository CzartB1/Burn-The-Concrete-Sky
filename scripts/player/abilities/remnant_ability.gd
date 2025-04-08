extends Player_Ability

@export var cooldown_timer:Timer
@export var area: PackedScene
@export var cooldown_bar: TextureProgressBar
@export var body: Node3D
var spawned=false
var buble
var cooldown=false

func _process(delta):
	super._process(delta)
	cooldownBarVisibility(delta)
	if spawned and !cooldown:
		if buble!=null:
			buble.global_position = global_position
			buble.global_rotation = body.global_rotation
		elif buble==null:
			cooldown_bar.value=0
			print("bubble dead timer start")
			cooldown_timer.start()
			spawned=false
			cooldown=true

func Ability():
	if spawned or cooldown: 
		if buble!=null:
			buble.queue_free()
	elif !spawned and !cooldown:
		buble = area.instantiate()
		get_tree().get_root().add_child(buble)
		spawned=true

func cooldown_timer_timeout():
	spawned=false
	cooldown=false

func cooldownBarVisibility(delta):
	if cooldown:
		cooldown_bar.visible=true
		cooldown_bar.max_value=cooldown_timer.wait_time
		var t=0.0
		t+=delta
		cooldown_bar.value=lerpf(cooldown_timer.wait_time,0,cooldown_timer.time_left)
		
	elif !cooldown:
		cooldown_bar.visible=true
		cooldown_bar.value=cooldown_bar.max_value
