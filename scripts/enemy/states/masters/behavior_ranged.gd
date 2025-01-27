extends Enemy_Behavior_Master

@export var muzzles: Array[Node3D]
@export var bullet: PackedScene
@export var fire_rate = 0.5
@export var damage = 5
@export var shoot_cooldown:Timer
@export var shoot_range = 30
@export var spread:float = 5
@export var stop_on_attack=false
@export_group("Ammo")
@export var max_ammo:int = 10
@export var reload_duration:float=3
@export var continual_attack:bool=false
@export_group("Animation")
@export var atk_anim_start_delay:float=0
@export var end_atk_anim_on_start:bool=true
var atk_anim_fin=true
var ammo:int
var can_shoot = true
var reloading=false
var previous_position: Vector3

func _ready():
	super._ready()
	ammo=max_ammo
	shoot_cooldown.wait_time=fire_rate
	previous_position = global_position

func _process(delta):
	super._process(delta)
	if continual_attack and is_attacking and can_shoot:
		look_at_player=true
		attack()
	if stop_on_attack: master.stop_nav=is_attacking

func attack():
	if can_shoot == false or master.stunned or reloading or master.global_position.distance_to(target)>shoot_range: return 
	if ammo > 0:
		if anim!=null and atk_anim_fin:  
			anim.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			if !end_atk_anim_on_start: 
				anim_wait()
		await get_tree().create_timer(atk_anim_start_delay).timeout
		for i in muzzles.size():
			var start_rot = muzzles[i].rotation_degrees.y
			muzzles[i].rotation_degrees.y += randf_range(-spread,spread)
			var instance = bullet.instantiate()
			get_tree().get_root().add_child(instance)
			instance.global_position = muzzles[i].global_position
			instance.rotation_degrees = muzzles[i].global_rotation_degrees
			if instance is Enemy_Bullet:
				instance.damage = damage
			muzzles[i].rotation_degrees.y = start_rot
		is_attacking = true
		can_shoot = false
		ammo-=1
		shoot_cooldown.start()
		attack_timer.start()
		
	elif ammo <= 0:
		reload()

func _on_shoot_cooldown_timeout():
	if can_shoot == false: can_shoot = true

func anim_wait():
	atk_anim_fin=false
	await anim.animation_finished
	#HACK maybe make some bool that defines if enemy will only end stop attacking when anim ends
	atk_anim_fin=true

func reload():
	is_attacking = true
	#stop=true
	reloading=true
	await get_tree().create_timer(reload_duration).timeout
	ammo=max_ammo
	#stop=false
	is_attacking = false
	reloading=false
