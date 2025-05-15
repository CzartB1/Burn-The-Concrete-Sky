class_name melee_weapon
extends Node3D

@export var manager: Weapon_Manager
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
var damage: int
@export_group("shop")
@export var price:int=100
@export_group("animation")
@export_range(2,3) var stance:int=3
@export_range(0,1) var strike_type:int=1
@export_group("lore")
@export var icon:AtlasTexture
@export_multiline var Description:String
@export_group("audio")
var audio_direct=preload("res://scene/utilities/audio_direct.tscn")
@export var attack_sound:AudioStream
var charging=false
var attacking: bool = false
var can_attack=true

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
	manager.master.anim_manager.set("parameters/weapon_anim_id/blend_position",float(stance))
	
	attack()

func attack():
	if !manager.master.alive and manager.master.disabled and game_manager.paused and manager.master.in_dialogue: return
	if can_attack and Input.is_action_just_pressed("attack") and !manager.master.in_dialogue:
		manager.master.charge_bar.max_value=max_damage
		charge_start=Time.get_ticks_msec()/1000.0
		charging=true
	if can_attack and Input.is_action_pressed("attack") and !manager.master.in_dialogue:
		if !charging:
			manager.master.charge_bar.max_value=max_damage
			charge_start=Time.get_ticks_msec()/1000.0
			charging=true
		elif charging:
			charge_dur=clamp(Time.get_ticks_msec()/1000.0-charge_start,0,3)
			manager.master.charge_bar.value=min_damage*(max_damage-min_damage)*charge_dur
	if can_attack and Input.is_action_just_released("attack") and charging and !manager.master.in_dialogue:
		var dec=get_tree().get_first_node_in_group("Decoy")
		if dec!=null and dec is Kunoichi_Decoy: dec.dead()
		
		play_sound(attack_sound)
		manager.master.charge_bar.value=0
		charge_dur=clamp(Time.get_ticks_msec()/1000.0-charge_start,0,3) #FIX ME sometimes crashes the game. maybe bcs it activated when another function thats needed isn't ready yet.
		damage=min_damage*(max_damage-min_damage)*charge_dur
		if damage > max_damage: damage=max_damage
		elif damage < min_damage: damage=min_damage
		print("final damage: "+str(damage))
		manager.master.anim_manager.set("parameters/melee_attack_type/blend_position",float(strike_type))
		manager.master.anim_manager.set("parameters/melee_attack/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		charging=false
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
