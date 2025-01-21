extends StateMachineState

@export var behavior: Enemy_Behavior_Master
# Called when the state machine enters this state.
func on_enter():
	pass


# Called every frame when this state is active.
func on_process(_delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	behavior.master.speed=0
	behavior.master.set_movement_target(behavior.master.global_position)
	var plrpos = behavior.target
	if plrpos == null: return
	if !behavior.disable_look: behavior.rotate_to(behavior.nav_agent.get_next_path_position(),delta)


# Called when there is an input event while this state is active.
func on_input(_event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass
