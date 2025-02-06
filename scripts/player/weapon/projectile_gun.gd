class_name Projectile_Gun
extends Node3D

@export var icon:AtlasTexture
@export var manager: Weapon_Manager
@export var muzzles: Array[Node3D]
@export var bullet: PackedScene
@export var fire_rate = 3.0
@export var damage = 8
@export var spread:float = 5
@export var pellets:int = 1
@export var shoot_range: float = 5.0
var can_shoot=true
@export_group("reloading")
@export var max_ammo:int=10
@export var reload_duration:float=2
var shoot_after_reload=true
var current_ammo:int
@export_subgroup("bullet counted reload")
@export var bullet_counted_reload=false
@export var bcr_insert_amount:int=1
var bcr_reloading=false
var bcr_can_reload=true
@export_group("visuals")
@export var muzzle_flash:Node3D
@export var anim_id=0
@export_group("audio")
var audio_direct=preload("res://scene/utilities/audio_direct.tscn")
@export var gunshot_sound:AudioStream
@export_group("shop")
@export var price:int=100

func _ready():
	current_ammo=max_ammo
	if muzzle_flash!=null:
		muzzle_flash.visible=false

func _process(_delta):
	#weapon animation
	manager.master.anim_manager.set("parameters/weapon_anim_id/blend_position",float(anim_id))
	
	if Input.is_action_pressed("attack")and manager.master.alive and !manager.master.disabled and can_shoot and !game_manager.paused:
		var dec=get_tree().get_first_node_in_group("Decoy")
		if dec!=null and dec is Kunoichi_Decoy: dec.dead()
		
		if current_ammo>0:
			shoot()
			bcr_reloading=false
		elif current_ammo<=0:
			empty()
	elif Input.is_action_just_released("attack"):
		shoot_after_reload=true
	if Input.is_action_just_pressed("reload") and current_ammo < max_ammo:
		shoot_after_reload=false
		if !bullet_counted_reload:
			reload()
		elif bullet_counted_reload:
			bcr_reloading=true
	#if manager.ammo_counter!=null:
		#if current_ammo>0:
			#manager.ammo_counter.text=str(current_ammo)
		#elif current_ammo<=0:
			#manager.ammo_counter.text="0"
	while bcr_reloading and current_ammo<max_ammo and bcr_can_reload and Input.is_action_pressed("reload"):
		bcr_reload()
		if current_ammo>=max_ammo:
			bcr_reloading=false
	if Input.is_action_just_released("reload"):bcr_reloading=false

func shoot(): #TODO add pellets for shotguns and stuff
	for k in pellets:
		for i in muzzles.size():
			var start_rot = muzzles[i].rotation_degrees.y
			var s1=randf_range(-(spread+manager.spread_modifier)*manager.spread_multiplier,(spread+manager.spread_modifier)*manager.spread_multiplier)
			var s2=randf_range((-(spread+manager.spread_modifier)*manager.spread_multiplier)/2,((spread+manager.spread_modifier)*manager.spread_multiplier)/2)
			muzzles[i].rotation_degrees.y += (s1+s2)/2
			muzzles[i].rotation_degrees.x=0
			muzzles[i].rotation_degrees.z=0
			var instance = bullet.instantiate()
			get_tree().get_root().add_child(instance)
			instance.global_position = muzzles[i].global_position
			instance.rotation_degrees = muzzles[i].global_rotation_degrees
			if instance is Player_Bullet:
				instance.damage = (damage+manager.damage_modifier)*manager.damage_multiplier
				instance.destroyTimer.wait_time=shoot_range
			muzzles[i].rotation_degrees.y = start_rot
	current_ammo-=1
	if gunshot_sound!=null:
		var audio=audio_direct.instantiate()
		add_child(audio)
		audio.play_sound(gunshot_sound)
	muzzle_flash_visual()
	can_shoot=false
	toggle_shoot()

func empty():
	shoot_after_reload=false
	if !bullet_counted_reload:
		reload()
	elif bullet_counted_reload:
		bcr_reloading=true

func reload():
	current_ammo=0
	await get_tree().create_timer(reload_duration).timeout
	current_ammo=max_ammo

func bcr_reload():
	bcr_can_reload=false
	await get_tree().create_timer(reload_duration).timeout
	current_ammo+=bcr_insert_amount
	bcr_can_reload=true

func toggle_shoot():
	await get_tree().create_timer(1/((fire_rate+manager.attack_speed_modifier)*manager.attack_speed_multiplier)).timeout
	can_shoot=true

func muzzle_flash_visual():
	if muzzle_flash!=null:
		muzzle_flash.visible=true
		await get_tree().create_timer(.1).timeout
		muzzle_flash.visible=false
