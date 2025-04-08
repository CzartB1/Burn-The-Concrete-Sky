extends Player_Ability

@export var cooldown_timer:Timer
@export var decoy_object: PackedScene
@export var cooldown_bar: TextureProgressBar
var spawned=false
var decoy
var cooldown=false

func _process(delta):
	super._process(delta)
	cooldownBarVisibility()
	if spawned and decoy==null and !cooldown:
		cooldown_bar.value=0
		cooldown_timer.start()
		spawned=false
		cooldown=true

func Ability():
	if spawned or cooldown: 
		if decoy!=null:
			if decoy is Kunoichi_Decoy:
				decoy.dead()
	elif !spawned and !cooldown:
		decoy = decoy_object.instantiate()
		get_tree().get_root().add_child(decoy)
		decoy.global_position = global_position
		spawned=true

func cooldown_timer_timeout():
	spawned=false
	cooldown=false

func cooldownBarVisibility():
	if cooldown:
		cooldown_bar.visible=true
		cooldown_bar.max_value=cooldown_timer.wait_time
		cooldown_bar.value=lerpf(cooldown_timer.wait_time,0,cooldown_timer.time_left)
		
	elif !cooldown:
		cooldown_bar.visible=true
		cooldown_bar.value=cooldown_bar.max_value

func destroy_decoy():
	if decoy!=null:
		if decoy is Kunoichi_Decoy:
			decoy.dead()
		decoy.queue_free()
