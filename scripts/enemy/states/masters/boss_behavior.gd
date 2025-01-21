extends Enemy_Behavior_Master

@export var phases:Array[Boss_Phase]
@export var current_phase:int
@export var health_bar:ProgressBar

@export var muzzles: Array[Node3D]
@export var bullet: PackedScene
@export var fire_rate = 0.5
@export var damage = 5
@export var shoot_cooldown:Timer
@export var shoot_range = 30
@export var spread:float = 5
@export_group("Ammo")
@export var max_ammo:int = 10
@export var reload_duration:float=3
var ammo:int
var can_shoot = true
var reloading=false
var first_s=false
var f_pos:Vector3

func _ready():
	super._ready()
	health_bar.max_value=master.hp
	for i in phases:
		i.behavior=self

func _process(delta):
	super._process(delta)
	health_bar.value=master.hp
	#for s in phases.size()-1:
		#if phases[s].hp_to_activate >= master.hp:
			#current_phase=s #TO DO list the phase from highest hp_to_activate to lowest

func states():
	phases[current_phase].states()
	for p in phases.size()-1:
		if p==current_phase:
			phases[p].active=true
		elif p!=current_phase:phases[p].active=false
	#TODO make health bar ui
	#TODO attacks
	#TODO changing phases

func attack():
	ranged()

func ranged():
	# i dont fucking know why, but if I put this code in the phases, the enemy will fly to the fucking stratosphere.
	if can_shoot == false or master.stunned or reloading or master.global_position.distance_to(target)>shoot_range: return 
	if ammo > 0:
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

func reload():
	is_attacking = true
	reloading=true
	await get_tree().create_timer(reload_duration).timeout
	ammo=max_ammo
	is_attacking = false
	reloading=false

func _on_shoot_cooldown_timeout():
	if can_shoot == false: can_shoot = true
