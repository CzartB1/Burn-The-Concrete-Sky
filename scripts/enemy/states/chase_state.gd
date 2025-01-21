extends StateMachineState

@export var behavior: Enemy_Behavior_Master
var target

# Called when the state machine enters this state.
func on_enter():
	pass

# Called every frame when this state is active.
func on_process(_delta):
	pass

func _physics_process(delta):
	#HACK to reduce enemies bunching together, do something like pacman AI. But, do it based on distance, and the closer they are, the more accurate the target is
	target = behavior.target
	
	if !behavior.master.stunned:
		if target == null: return
		behavior.master.set_movement_target(target)
		if !behavior.look_at_player and !behavior.disable_look and behavior.master.global_position.distance_to(behavior.master.navigation_agent.get_next_path_position()) > 1:
			behavior.rotate_to(behavior.nav_agent.get_next_path_position(),delta)
	elif behavior.master.stunned:
		behavior.master.velocity = Vector3.ZERO

# Called when there is an input event while this state is active.
func on_input(_event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass
