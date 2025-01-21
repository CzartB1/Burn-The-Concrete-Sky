class_name Boss_Phase
extends Node3D

@export var hp_to_activate:int
var active:bool
var activated:bool
var behavior:Enemy_Behavior_Master
var attacking=false

func states(): #TODO use super.states if new states is added
	if behavior.stop and behavior.master.alive or behavior.master.stunned: 
		behavior.state_machine.current_state = behavior.idle_state
	elif !behavior.stop and behavior.master.alive and !behavior.master.stunned:
		behavior.master.rotation = Vector3(0,behavior.master.rotation.y,0)
		if behavior.plrdist > behavior.dist_to_chase and behavior.plrdist > behavior.dist_to_avoid:
			behavior.state_machine.current_state = behavior.chase_state
		if behavior.plrdist < behavior.dist_to_avoid and behavior.plrdist < behavior.dist_to_chase and behavior.will_avoid:
			behavior.state_machine.current_state = behavior.avoid_state
		if behavior.plrdist >= behavior.dist_to_avoid and behavior.plrdist <= behavior.dist_to_chase:
			if behavior.look_at_player and behavior.will_stop_on_close:
				behavior.state_machine.current_state = behavior.idle_state
			elif !behavior.look_at_player:
				behavior.state_machine.current_state = behavior.chase_state

func perform_attack():
	#TODO if u forget how to make boss phases
	#if u forget, make each attack are a unique func
	#make an extension of this func with conditions and rng to choose which attack is performed
	print("Attacking")

func _process(delta):
	if active and !activated:activated=true
	if hp_to_activate >= behavior.master.hp and !active and !activated and behavior.current_phase!=behavior.phases.find(self):
		behavior.current_phase=behavior.phases.find(self) 
		activated=true
