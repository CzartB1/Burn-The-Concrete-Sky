extends StateMachineState

@export var behavior: Enemy_Behavior_Master

func on_physics_process(delta):
	#var plrpos = get_tree().get_first_node_in_group("Player").global_position
	var plrpos = behavior.target
	
	var direction = behavior.master.global_position.direction_to(plrpos)
	behavior.target = behavior.master.global_position - direction * behavior.dist_to_avoid
	behavior.nav_agent.target_position = behavior.target
	var _current_location = behavior.master.global_transform.origin
	var next_location = behavior.nav_agent.get_next_path_position()
	var nl_flat = Vector3(next_location.x, behavior.master.global_position.y, next_location.z)
	behavior.master.global_position = behavior.master.global_position.move_toward(next_location, delta * behavior.speed*0.15)
	behavior.rotate_to(behavior.nav_agent.get_next_path_position(),delta)
	if behavior.master.global_position.distance_to(nl_flat) > 0.1:
		behavior.move_done = false
	else:
		behavior.move_done = true
