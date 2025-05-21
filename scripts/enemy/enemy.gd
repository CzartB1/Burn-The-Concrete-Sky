class_name Enemy
extends CharacterBody3D

@export var hp = 10
@export var elite=false
@export var tags: Array[String] = []
@export var death_delay:float = 0
var alive = true
var spawner:enemy_spawner
var speed:float
var stunned=false
var distraction: Node3D
var damage_taken_mult=1
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
@export var flash_color: Color = Color(1, 0, 0) # Default: Red
@export var flash_duration: float = 0.15
@export var mesh_instances:Array[MeshInstance3D]
@export_group("audio")
var audio_direct=preload("res://scene/utilities/audio_direct.tscn")
@export var hurt_sound:AudioStream
var original_materials: Dictionary = {}
var flashing: bool = false
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
	if navigation_agent.is_navigation_finished() or stunned: return
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
	flash()
	hp-=damage*damage_taken_mult
	if hurt_sound!=null:play_sound(hurt_sound)
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

func flash():
	if flashing: return
	flashing = true

	if mesh_instances:
		# Save the original material (could be null)
		for m in mesh_instances: #FIXME this flashes the meshes one by one, not all of them at once. It should've flash all of em
			if not original_materials.has(m):
				original_materials[m] = m.material_override
			var flash_material = StandardMaterial3D.new()
			flash_material.albedo_color = flash_color
			m.material_override = flash_material

			# Wait for flash_duration seconds before restoring the original material
		await get_tree().create_timer(flash_duration).timeout
		for mesh in mesh_instances:
			if original_materials.has(mesh):
				mesh.material_override = original_materials[mesh]
	elif !mesh_instances:
		printerr(name + " can't detect its mesh for the flashing effect when damaged. Please rename its mesh or adjust the hierarchy. mesh_instance location from the parent enemy should be: /mesh/metarig/Skeleton3D/Character")
	flashing = false

func play_sound(austr:AudioStream):
	if austr!=null:
		var audio=audio_direct.instantiate()
		var plr=get_tree().get_first_node_in_group("Player")
		plr.add_child(audio)
		audio.play_sound(austr)
	elif !austr:
		print("sound not found")

func has_tag(tag: String) -> bool:
	return tag in tags

func get_tags() -> String:
	var result := ""
	for tag in tags:
		result += "[ " + tag.capitalize() + " ] "
	return result.strip_edges()
