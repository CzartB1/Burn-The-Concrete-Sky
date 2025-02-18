class_name Gladiator_Ability
extends Player_Ability

@export var cooldown_timer:Timer
@export var hook_object: PackedScene
@export var cooldown_bar: ProgressBar
@export var body: Node3D
@export var grapple_max_time: float=0.75
@export var dist_to_disengage: float=2.5
var grapple_start: float
var spawned=false
var hook
var cooldown=false
var target:Vector3
var locked_in:bool=false

func _process(delta):
	super._process(delta)
	cooldownBarVisibility(delta)
	if locked_in:
		if plr.global_position.distance_to(target)>dist_to_disengage and Time.get_unix_time_from_system()*Engine.time_scale-grapple_start<grapple_max_time:
			#target.stunned=true
			#plr.global_transform.origin = lerp(plr.global_transform.origin, target, 0.075)
			if Input.is_action_just_pressed("attack"):
				#FIXME stun target if target is enemy
				#FIXME sometimes, grapple doesnt register. Prob because of occlussion culling
				locked_in=false
		else:
			locked_in=false
	#plr.can_move=!locked_in

func Ability():
	if!cooldown and !locked_in:
		hook = hook_object.instantiate()
		get_tree().get_root().add_child(hook)
		hook.global_position = global_position
		hook.global_rotation_degrees = body.global_rotation_degrees 
		if hook is Gladiator_Hook:
			hook.master=self
		cooldown_bar.value=0
		cooldown_timer.start()
		spawned=true
		cooldown=true
		grapple_start=Time.get_unix_time_from_system()

func cooldown_timer_timeout():
	spawned=false
	cooldown=false

func cooldownBarVisibility(delta):
	if cooldown:
		cooldown_bar.visible=true
		cooldown_bar.max_value=cooldown_timer.wait_time
		cooldown_bar.value=lerpf(cooldown_timer.wait_time,0,cooldown_timer.time_left)
	elif !cooldown:
		cooldown_bar.visible=true
		cooldown_bar.value=cooldown_bar.max_value

func pull_enemy(enemy: Node3D, pull_speed: float = 500.0, stop_distance: float = 2.0) -> void:
	if enemy == null: return
	var direction = (global_position - enemy.global_position).normalized()
	var target_position = global_position - (direction * stop_distance)
	if enemy.global_position.distance_to(global_position) <= stop_distance: return  
	var distance = enemy.global_position.distance_to(target_position)
	var duration = distance / pull_speed if pull_speed > 0.0 else 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(enemy, "global_position", target_position, duration)
