extends Boss_Phase

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
	ammo=max_ammo
	shoot_cooldown.wait_time=fire_rate

func perform_attack():
	ranged()

func ranged():
	# TODO make like kind of a for statement for burst shooting
	if can_shoot == false or behavior.master.stunned or reloading or behavior.master.global_position.distance_to(behavior.target)>shoot_range: return 
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
		behavior.is_attacking = true
		can_shoot = false
		ammo-=1
		shoot_cooldown.start()
		behavior.attack_timer.start()
	elif ammo <= 0:
		reload()

func reload():
	behavior.is_attacking = true
	reloading=true
	await get_tree().create_timer(reload_duration).timeout
	ammo=max_ammo
	behavior.is_attacking = false
	reloading=false

func _on_attack_timer_timeout():
	if can_shoot == false: can_shoot = true
