class_name Player
extends CharacterBody3D

@export_group("Stat")
@export var upgrade_manager: Player_Upgrade_Manager
@export var hp = 20
@export var damage_taken_multiplier = 1
@export  var HP_bar: ProgressBar
@export  var time_slow_bar: TextureProgressBar
@onready var cursor_icon: Control=$player_HUD/HUD/mouse_icon
@onready var letter_box: Letterbox=$player_HUD/letterboxing
@export var charge_bar: ProgressBar
var death_screen:Death_Screen
var alive = true
var invulnerable=false
@export_group("movement")
var can_move=true
var disabled=false
# At the class level, define the two velocity vectors:
var input_velocity: Vector3 = Vector3.ZERO
var external_velocity: Vector3 = Vector3.ZERO
var vel: Vector3 = Vector3.ZERO
# Set how quickly external pushes fade away.
var external_decay_rate: float = 10.0
@export var body:Node3D
@export var move_speed = 12
@export_subgroup("Move Modifiers")
@export var move_speed_modifier = 0
@export var move_speed_multiplier = 1.0
var speed
@export_subgroup("Dashing")
@export var dash_amount = 1
@export var dash_speed = 100
@export var dash_duration = 0.1
@export var dash_cooldown = 1.0
@onready var dash_timer = $dash_timer
@onready var dash_cooldown_timer = $dash_cooldown
@export_subgroup("Dash Modifiers")
@export var dash_speed_modifier = 0.0
@export var dash_speed_multiplier = 1.0
var current_dash_amount
var dashing = false
var recharging_dash = false
@export_subgroup("Time Slow")
@export var time_slow_duration_max = 30.0
@export var time_slow_recharge_multiplier=10
@export var time_slow_decrease_multiplier=10
@export var focus_zoom_size:float=18
@export var time_slow_speed_mult:float=1.8
var total_speed_mult
var time_slow_duration
var time_slowed = false
@export_subgroup("Controller")
@export var controller:bool = false
@export var cont_look_target: Node3D
@export var cont_target_sensitivity:float = 1
@export var cont_target_max_distance:float = 7
@export_group("camera")
@export var cam: Camera3D
@export var cam_holder:Cam_Holder
var cam_normal_size
var ray_origin = Vector3()
var ray_target = Vector3()
var show_cursor = false
var mousepos
@export_group("animation")
@export var anim_manager:AnimationTree
@export_group("music")
@export var combat_music_index:int=0 #HACK if you wanna change the music, add it to the combat music list in the musicmanager and set this to its index

func _ready():
	speed = (move_speed+move_speed_modifier)*move_speed_multiplier
	current_dash_amount = dash_amount
	dash_timer.wait_time = dash_duration
	HP_bar.max_value = hp
	HP_bar.value = hp
	time_slow_duration = time_slow_duration_max
	time_slow_bar.max_value = time_slow_duration_max
	Engine.time_scale = 1.0
	letter_box=get_tree().get_first_node_in_group("l8rbox")
	if cam:cam_normal_size=cam.size
	total_speed_mult=move_speed_multiplier
	

func _process(delta):
	HP_bar.value = hp
	time_slow_bar.value = time_slow_duration
	if !cam: cam=get_tree().get_first_node_in_group("playercamera")
	if alive:
		if controller:
			cursor_icon.set_position(cam.unproject_position(cont_look_target.global_position))
		elif !controller:
			cursor_icon.set_position(get_viewport().get_mouse_position())
	elif !alive:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		HP_bar.visible = false
	
	if !alive: return
	ground_check()
	if dashing:
		dash_timer.wait_time = dash_duration
		speed = lerp(speed,(dash_speed+dash_speed_modifier)*dash_speed_multiplier,delta*15)
		if velocity == Vector3.ZERO: dashing = false
	elif !dashing:
		if time_slowed:speed = lerp(speed,(move_speed+move_speed_modifier)*total_speed_mult,delta*15)#HACK make them faster when time is slowed
		elif !time_slowed:speed = lerp(speed,(move_speed+move_speed_modifier)*total_speed_mult,delta*15)
	
	if Input.is_action_just_pressed("move_dash") and current_dash_amount > 0:
		dashing = true
		current_dash_amount-=1
		dash_timer.start()
	if current_dash_amount < dash_amount and !recharging_dash:
		dash_cooldown_timer.start()
		recharging_dash = true
	elif current_dash_amount >= dash_amount:
		dash_cooldown_timer.stop()
		recharging_dash = false
	
	if hp <= 0:
		death()
	
	if Input.is_action_just_pressed("slow_time") and !game_manager.paused:
		if letter_box==null: letter_box = get_tree().get_first_node_in_group("l8rbox")
		if time_slowed:
			var cam_size_tween=create_tween()
			Engine.time_scale = 1.0
			AudioServer.playback_speed_scale=1.0
			letter_box.show_box=false
			time_slowed=false
			cam_size_tween.tween_property($cam_holder/Camera3D,"size",cam_normal_size,1*Engine.time_scale)
		elif !time_slowed:
			var cam_size_tween=create_tween()
			Engine.time_scale = 0.2
			AudioServer.playback_speed_scale=0.2
			letter_box.show_box=true
			time_slowed=true
			cam_size_tween.tween_property($cam_holder/Camera3D,"size",focus_zoom_size,1*Engine.time_scale)
	if time_slowed:
		total_speed_mult=move_speed_multiplier*time_slow_speed_mult
		time_slow_duration-=delta*time_slow_decrease_multiplier/Engine.time_scale
		if time_slow_duration <= 0:
			var cam_size_tween=create_tween()
			Engine.time_scale = 1.0
			AudioServer.playback_speed_scale=1.0
			letter_box.show_box=false
			time_slowed=false
			cam_size_tween.tween_property($cam_holder/Camera3D,"size",cam_normal_size,1*Engine.time_scale)
	elif !time_slowed:
		total_speed_mult=move_speed_multiplier
		if time_slow_duration < time_slow_duration_max:
			time_slow_duration += delta*time_slow_recharge_multiplier/Engine.time_scale
	game_manager.time_slowed=time_slowed
	
	if show_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursor_icon.visible = false
	elif !show_cursor:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		cursor_icon.visible = true
	
	var plr_check=get_tree().get_nodes_in_group("Player")
	for p in plr_check.size()-1:
		if p < 0:
			plr_check[p].queue_free()

func _physics_process(delta):
	if alive and !disabled:
		look(delta)
		move(delta)
	elif disabled: 
		# when choosing a starting weapon, the player can still move
		# and when they change room when theyre still in the weapons menu, they cant exit
		# so, I just forced the plr controller to stop :D *secretly in tears from the hours fixing this
		velocity=Vector3.ZERO
	move_and_slide()

func move(delta):
	# Capture the player's directional will.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and !disabled and can_move:
		# Compute the desired input velocity.
		var target_velocity = direction * speed
		# Use a high acceleration for responsive movement.
		var acceleration = 20.0
		input_velocity.x = lerp(input_velocity.x, target_velocity.x, acceleration * delta)
		input_velocity.z = lerp(input_velocity.z, target_velocity.z, acceleration * delta)
	else:
		# Without player input, the controlled momentum vanishes instantly.
		input_velocity.x = 0
		input_velocity.z = 0
	
	# Allow external forces to persist and gradually fade.
	external_velocity.x = move_toward(external_velocity.x, 0, external_decay_rate * delta)
	external_velocity.z = move_toward(external_velocity.z, 0, external_decay_rate * delta)
	
	if !is_on_floor(): input_velocity.y=get_gravity().y
	
	# The final motion is the sum of the player's intent and the world's impulse.
	velocity = input_velocity + external_velocity


func _input(event):
	if event is InputEventMouseMotion or event is InputEventMouseButton:controller = false
	elif event is InputEventJoypadMotion or event is InputEventJoypadButton:controller = true

func look(delta):
	if !controller:
		mousepos = get_viewport().get_mouse_position()
		ray_origin = cam.project_ray_origin(mousepos)
		ray_target = ray_origin + cam.project_ray_normal(mousepos) * 2000
		var space_state = get_world_3d().direct_space_state
		var params = PhysicsRayQueryParameters3D.new()
		params.from = ray_origin + Vector3.UP
		params.to = ray_target
		#params.collision_mask = get_collision_mask_value(16)
		params.exclude = []
		var intersection = space_state.intersect_ray(params)
		if not intersection.is_empty():
			var pos = Vector3(intersection.position.x, global_position.y,intersection.position.z)
			body.look_at(pos, Vector3.UP)
	elif controller:
		var stick_pos = Input.get_vector("joystick_look_left", "joystick_look_right", "joystick_look_up", "joystick_look_down")
		if body.position.distance_to(cont_look_target.position)<cont_target_max_distance:
			cont_look_target.position = Vector3(stick_pos.x,0,stick_pos.y)*cont_target_max_distance
		elif body.position.distance_to(cont_look_target.position)>=cont_target_max_distance:
			cont_look_target.position=cont_look_target.position.move_toward(body.position,delta*10)
		var cont_body_flat = Vector3(cont_look_target.global_position.x, body.global_position.y, cont_look_target.global_position.z)
		body.look_at(cont_body_flat, Vector3.UP)

func _on_dash_timer_timeout():
	dashing = false
	dash_cooldown_timer.start()

func _on_dash_cooldown_timeout():
	current_dash_amount = dash_amount
	if current_dash_amount < dash_amount:
		dash_timer.start()

func take_damage(damage:int):
	if !dashing and !invulnerable:
		print(name + " took " + str(damage) + " damage")
		hp-=damage*damage_taken_multiplier
		var econom=get_tree().get_first_node_in_group("Economy")
		if econom is Player_Economy_Manager:
			econom.mult_reset(true)

func death():
	game_manager.stop_count_time()
	alive = false
	death_screen=get_tree().get_first_node_in_group("death_screen")
	show_cursor=true
	Engine.time_scale = 0.2
	print("player died")
	velocity = Vector3.ZERO
	death_screen.activate()

func revive():
	alive = true
	print("player revived")
	Engine.time_scale = 1

func ground_check():
	if is_on_floor(): velocity.y=0
	elif !is_on_floor(): velocity.y=-1
