class_name melee_weapon
extends BaseWeapon

@export var hitbox: Area3D
@export var visual_effects: Node3D
@export var deflect_bullet:bool=false
@export var cooldown_timer:Timer
var ignore_bodies:Array=[]
@export_group("damage")
@export var min_damage: int = 2
@export var damage_add_over_time: int = 1
@export var max_damage: int = 15
var charge_start
var charge_dur
var damage_add: int
var damage_mult: int =1
var damage: int
@export_group("animation")
@export_range(2,3) var stance:int=3
@export_range(0,1) var strike_type:int=1
@export_group("audio")
@export var attack_sound:AudioStream
var attacking: bool = false

func _physics_process(delta):
	if attacking:
		visual_effects.visible = true
		for body in hitbox.get_overlapping_bodies():
			if body is Enemy and !ignore_bodies.has(body):
				OS.delay_msec(50)
				body.take_damage(damage,global_position)
			if body is Enemy_Bullet and !ignore_bodies.has(body):
				if !deflect_bullet: 
					pass
				elif deflect_bullet and !body.deflected:
					OS.delay_msec(50)
					body.deflect()
					print("bullet deflected")
			if body is enemy_shield and !ignore_bodies.has(body):
				body.take_damage(damage,global_position)
			ignore_bodies.append(body)
	elif !attacking:
		visual_effects.visible = false

func _process(delta):
	super._process(delta)
	manager.master.anim_manager.set("parameters/weapon_anim_id/blend_position",float(stance))

func attack_press():
	manager.master.charge_bar.max_value=max_damage
	charge_start=Time.get_ticks_msec()/1000.0

func attack_hold():
	if !holding:
		manager.master.charge_bar.max_value=max_damage
		charge_start=Time.get_ticks_msec()/1000.0
	elif holding:
		charge_dur=clamp(Time.get_ticks_msec()/1000.0-charge_start,0,3)
		manager.master.charge_bar.value=min_damage*(max_damage-min_damage)*charge_dur

func attack_released():
	if !charge_start: return
	var dec=get_tree().get_first_node_in_group("Decoy")
	if dec!=null and dec is Kunoichi_Decoy: dec.dead()
	play_sound(attack_sound)
	manager.master.charge_bar.value=0
	charge_dur=clamp(Time.get_ticks_msec()/1000-charge_start,0,3)
	damage=((min_damage*(max_damage-min_damage)*charge_dur*damage_mult)+manager.damage_modifier)*manager.damage_multiplier
	if damage > max_damage*damage_mult: damage=max_damage*damage_mult
	elif damage < min_damage*damage_mult: damage=min_damage*damage_mult
	print("final damage: "+str(damage))
	manager.master.anim_manager.set("parameters/melee_attack_type/blend_position",float(strike_type))
	manager.master.anim_manager.set("parameters/melee_attack/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attacking = true
	await get_tree().create_timer(0.1).timeout
	attacking = false
	can_attack=false
	cooldown_timer.start()

func _on_cooldown_timeout():
	ignore_bodies.clear()
	damage_add=0
	can_attack=true

func play_sound(austr:AudioStream):
	if austr!=null:
		var audio=audio_direct.instantiate()
		add_child(audio)
		audio.play_sound(austr)
	elif !austr:
		print("sound not found")
