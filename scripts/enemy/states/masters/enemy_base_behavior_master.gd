class_name Enemy_Behavior_Master
extends Node3D


@export var master:Enemy
@export var state_machine: FiniteStateMachine
@export var speed = 7.0
@export var dist_to_chase = 3.0
@export var dist_to_avoid = 2.5
@onready var nav_agent:NavigationAgent3D = $NavigationAgent3D
var stop = false
var target
var plrpos
var move_done
var plrdist
@export_group("Combat")
@export var aim_speed=5.0
@export var aim_node:Node3D
@export var attack_timer:Timer
@export var attack_speed: float = 3
@export var attack_prepare_duration:float=0
var is_attacking = false
@export var look_ray:RayCast3D
var look_at_player = false
var disable_look=false
var will_avoid=true
var will_stop_on_close=true
@export_group("States")
@export var dead_state: StateMachineState
@export var idle_state: StateMachineState
@export var chase_state: StateMachineState
@export var avoid_state: StateMachineState
@export_group("anim")
@export var anim:AnimationTree
@export var anim_move_smooth: float = 5.0   # Speed of the smooth transition
var anim_move_state: float = 0.0  # whether running or not
var current_speed: float

func _ready():
	target = global_position
	plrpos = get_tree().get_first_node_in_group("Player").global_position
	plrdist = global_position.distance_to(plrpos)
	nav_agent.avoidance_enabled=true
	nav_agent.debug_enabled=false
	current_speed = 0.0

func _process(delta): # HACK spread the pathfinding update so each enemies update in different frames and not at the same time to reduce workload
	plrpos = get_tree().get_first_node_in_group("Player").global_position
	var pl_flat = Vector3(plrpos.x,master.global_position.y,plrpos.z)
	if master.distraction != null:
		var de_flat = Vector3(master.distraction.global_position.x,master.global_position.y,master.distraction.global_position.z)
		target = de_flat
		plrdist = global_position.distance_to(target)
		if !disable_look:look_ray.look_at(target)
	elif master.distraction == null:
		target = pl_flat
		plrdist = global_position.distance_to(target)
		if !disable_look:look_ray.look_at(target)
	
	states()
	
	aim(delta)
	
	if is_attacking and state_machine.current_state!=idle_state:
		master.speed = attack_speed
	elif !is_attacking and state_machine.current_state!=idle_state:
		master.speed = speed
	
	if master.stunned:
		stop=true
	
	var is_moving = master.navigation_agent.velocity.length() > 0.01  # Small threshold to avoid noise
	var target_value = 1.0 if is_moving else 0.0
	anim_move_state = lerp(anim_move_state, target_value, anim_move_smooth * delta)
	
	if anim!=null: 
		if master.alive: 
			anim.active=true
			anim.set("parameters/moveBlend/blend_position", anim_move_state) # don't abs or ceil this. It'll stutter. And it's broken as it is
		elif !master.alive: anim.active=false
	print("Current Speed: ", current_speed)

func aim(delta):
	if master.stunned:return
	if master.distraction == null: # if there's no decoys
		if look_ray.collide_with_bodies and look_ray.get_collider() is Player and !master.stunned:
			look_at_player = true
			if look_ray.get_collider().alive:
				if !disable_look: 
					rotate_to(target,delta)
				prepare_attack()
		else:
			look_at_player = false
	elif master.distraction != null: #for decoys.. fuck kunoichi, man
		if look_ray.collide_with_bodies and look_ray.get_collider() is Kunoichi_Decoy and !master.stunned:
			look_at_player = true
			if !disable_look: #HACK disable if target is near, ig... to remove the error
				rotate_to(target,delta)
			prepare_attack()
		else:
			look_at_player = false
	else:
		look_at_player = false

func states():
	if stop and master.alive or master.stunned: 
		state_machine.current_state = idle_state
	elif !stop and master.alive and !master.stunned:
		master.rotation = Vector3(0,master.rotation.y,0)
		if plrdist > dist_to_chase and plrdist > dist_to_avoid:
			state_machine.current_state = chase_state
		if plrdist < dist_to_avoid and plrdist < dist_to_chase and will_avoid:
			state_machine.current_state = avoid_state
		if plrdist >= dist_to_avoid and plrdist <= dist_to_chase:
			if look_at_player and will_stop_on_close:
				state_machine.current_state = idle_state
			elif !look_at_player:
				state_machine.current_state = chase_state

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	master.velocity = master.velocity.move_toward(safe_velocity,.25)
	master.move_and_slide()

func prepare_attack():
	#TODO add preparing indicator
	#TODO when attacked while preparing, cancel the attack and add multiplier
	await get_tree().create_timer(attack_prepare_duration).timeout
	attack()

func attack():
	pass

func _on_attack_timer_timeout():
	is_attacking=false

func rotate_to(subject:Vector3, delta):
	#HACK make it slower when tiem is slowed
	aim_node.global_position=master.global_position
	if subject!=aim_node.position: aim_node.look_at(subject)
	master.rotation.y=lerp_angle(master.rotation.y,aim_node.rotation.y,aim_speed*delta)
