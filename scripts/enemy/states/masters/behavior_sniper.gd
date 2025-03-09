extends Enemy_Behavior_Master

@export var muzzles: Array[Node3D]
@export var bullet: PackedScene
@export var fire_rate = 2
@export var damage = 10
@export var shoot_cooldown:Timer
@export var shoot_range = 45
@export var spread:float = 0
@export var aim_time:float=1
@export var laser:Line_Renderer
var in_sight=false
@export_group("Ammo")
@export var max_ammo:int = 5
@export var reload_duration:float=5
var ammo:int
var can_shoot = true
var reloading=false

func _ready():
	super._ready()
	ammo=max_ammo
	shoot_cooldown.wait_time=fire_rate

func _process(_delta):
	super._process(_delta)
	#stop=is_attacking
	if in_sight:
		laser.visible=true
		laser.points[0]=master.global_position
		laser.points[1]=target
	elif !in_sight:
		laser.visible=false

func attack():
	if can_shoot == false or master.stunned or reloading or !look_at_player: return 
	if ammo > 0:
		stop=true
		#looking=false
		is_attacking = true
		can_shoot = false
		in_sight=true
		await get_tree().create_timer(aim_time).timeout
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
		ammo-=1
		in_sight=false
		shoot_cooldown.start()
		attack_timer.start()
	elif ammo <= 0:
		reload()

func _on_shoot_cooldown_timeout():
	stop=false
	#looking=true
	if can_shoot == false: 
		can_shoot = true

func reload():
	is_attacking = true
	#stop=true
	reloading=true
	await get_tree().create_timer(reload_duration).timeout
	ammo=max_ammo
	#stop=false
	is_attacking = false
	reloading=false
