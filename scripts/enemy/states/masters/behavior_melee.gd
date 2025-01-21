extends Enemy_Behavior_Master

@export var damage = 2
@export var visual_effects: Node3D
@export var hitbox: Area3D
@export var dist_to_attack = 2.0
@export_group("attack")
@export var attack_dur=0.1
@export var buildup_dur=0.5
var can_attack=true
var hit=false

func _process(delta):
	#TODO make enemy encircle player before attackign them
	super._process(delta)
	if is_attacking:
		visual_effects.visible = true
		for body in hitbox.get_overlapping_bodies():
			if body is Player and !hit:
				body.take_damage(damage)
				hit=true
	elif !is_attacking:
		visual_effects.visible = false

func attack():
	if !can_attack or master.global_position.distance_to(target)>dist_to_attack:return
	anim.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(buildup_dur).timeout
	can_attack=false
	is_attacking = true
	await get_tree().create_timer(attack_dur).timeout
	is_attacking = false
	$cooldown_timer.start()

func _on_cooldown_timer_timeout():
	can_attack=true
	hit=false
