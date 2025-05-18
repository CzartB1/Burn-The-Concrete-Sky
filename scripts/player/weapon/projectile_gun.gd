class_name Projectile_Gun
extends BaseWeapon

@export var muzzles: Array[Node3D]
@export var bullet: PackedScene
@export var fire_rate = 3.0
@export var damage = 8
@export var spread:float = 5
@export var pellets:int = 1
@export var shoot_range: float = 5.0
@export_group("reloading")
@export var max_ammo:int=10
@export var reload_duration:float=2
var shoot_after_reload=true
var current_ammo:int
var is_reloading=false
@export_subgroup("bullet counted reload")
@export var bullet_counted_reload=false
@export var bcr_insert_amount:int=1
var bcr_reloading=false
var bcr_can_reload=true
@export_group("visuals")
@export var muzzle_flash:Node3D
@export var anim_id=0
@export_group("audio")
@export var gunshot_sound:AudioStream
@export var reload_sound:AudioStream
@export var bcr_finish_sound:AudioStream

func _ready():
	current_ammo=max_ammo
	if muzzle_flash!=null:
		muzzle_flash.visible=false

func _process(_delta):
	super._process(_delta)
	#weapon animation
	manager.master.anim_manager.set("parameters/weapon_anim_id/blend_position",float(anim_id))
	
	if Input.is_action_just_pressed("reload") and current_ammo < max_ammo:
		shoot_after_reload=false
		if !bullet_counted_reload:
			reload()
		elif bullet_counted_reload:
			bcr_reloading=true
	while bcr_reloading and current_ammo<max_ammo and bcr_can_reload and Input.is_action_pressed("reload"):
		play_sound(reload_sound)
		bcr_reload()
		if current_ammo>=max_ammo:
			bcr_reloading=false
			play_sound(bcr_finish_sound)
	if Input.is_action_just_released("reload"):bcr_reloading=false

func attack_hold():
	var dec=get_tree().get_first_node_in_group("Decoy")
	if dec!=null and dec is Kunoichi_Decoy: dec.dead()
	
	if current_ammo>0:
		shoot()
		bcr_reloading=false
	elif current_ammo<=0:
		empty()

func attack_released():
	shoot_after_reload=true

func shoot():
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
	play_sound(gunshot_sound)
	muzzle_flash_visual()
	can_attack=false
	toggle_shoot()

func empty():
	shoot_after_reload=false
	if !bullet_counted_reload:
		reload()
	elif bullet_counted_reload:
		bcr_reloading=true

func reload():
	if is_reloading:return
	is_reloading=true
	current_ammo=0
	play_sound(reload_sound)
	await get_tree().create_timer(reload_duration).timeout
	if is_reloading: #there was a glitch where the gun will still max the bullet for some time after reloading. this is the fix.
		current_ammo=max_ammo
		is_reloading=false

func bcr_reload():
	is_reloading=true
	bcr_can_reload=false
	await get_tree().create_timer(reload_duration).timeout
	current_ammo+=bcr_insert_amount
	bcr_can_reload=true
	is_reloading=false

func toggle_shoot():
	await get_tree().create_timer(1/((fire_rate+manager.attack_speed_modifier)*manager.attack_speed_multiplier)).timeout
	can_attack=true

func muzzle_flash_visual():
	if muzzle_flash!=null:
		muzzle_flash.visible=true
		await get_tree().create_timer(.1).timeout
		muzzle_flash.visible=false
