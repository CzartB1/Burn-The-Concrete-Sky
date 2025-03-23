class_name Enemy
extends CharacterBody3D

@export var hp = 10
@export var elite=false
@export var death_delay:float = 0
var alive = true
var spawner:enemy_spawner
var speed:float
var stunned=false
var distraction: Node3D
@export var navigation_agent: NavigationAgent3D
@export var anim: AnimationPlayer
@export_group("loot")
@onready var money_scene: PackedScene=preload("res://scene/money.tscn")
@export var money_amount: int = 10
@export var money_impulse_min: float = 0.5
@export var money_impulse_max: float = 8.0
@export var mult_loot = 1.0
@export_group("gore")
@export var gore_manager:Gore_Manager
var stop_nav=false
var hp_start:int

func _ready():
	hp_start=hp

func _process(_delta):
	if hp <= 0:
		alive = false
		stop_nav=true
		if anim!=null and anim.has_animation("metarig | death"):
			 
			anim.play("metarig | death")
		if death_delay>0: await get_tree().create_timer(death_delay).timeout
		game_manager.stat_kills+=1
		if spawner!=null:
			if elite:spawner.elites_killed+=1
			elif !elite:spawner.common_spawned-=1
		var econom=get_tree().get_first_node_in_group("Economy")
		if econom is Player_Economy_Manager:
			econom.increase_mult(mult_loot)
		explode_money()
		gore_manager.activate_death_effect()
		queue_free()

func set_movement_target(movement_target: Vector3):
	navigation_agent.target_position=movement_target

func _physics_process(_delta):
	if is_on_floor(): velocity.y=0
	elif !is_on_floor(): velocity.y=-19
	if navigation_agent.is_navigation_finished() or stunned:
		return
	if !stop_nav and alive:
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		var current_agent_position: Vector3 = global_position
		var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * speed
		if navigation_agent.avoidance_enabled:
			navigation_agent.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)
	else: _on_velocity_computed(Vector3.ZERO)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func take_damage(damage:int,attacker:Vector3=global_position):
	#print(name.get_basename() + " took " + str(damage) + " damage")
	hp-=damage
	if gore_manager!=null:
		gore_manager.mist_activate(attacker)
		if hp>0:
			gore_manager.shoot_squirt(attacker)
		elif hp<=0: gore_manager.shoot_splatters(attacker)

func explode_money():
	if not money_scene:
		print_debug("Money scene is not assigned.")
		return

	for i in range(money_amount):
		# Instance the money scene
		var money = money_scene.instantiate() as RigidBody3D
		if money:
			# Add the money to the scene
			get_tree().current_scene.add_child(money)

			# Position the money at the enemy's position
			money.global_transform.origin = global_transform.origin

			# Generate a truly random direction on the unit sphere
			var random_direction = Vector3(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
			).normalized()

			# Avoid 0-length vectors due to rare normalization issues
			if random_direction.length() == 0:
				random_direction = Vector3(1, 0, 0)  # Default fallback direction

			# Apply a random impulse to the money
			var random_impulse = random_direction * randf_range(money_impulse_min, money_impulse_max)
			money.apply_impulse(random_impulse)
