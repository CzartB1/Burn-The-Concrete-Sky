class_name Player_Ability
extends Node3D

var plr:Player

func _process(_delta):
	if plr==null: plr=get_tree().get_first_node_in_group("Player")
	if Input.is_action_just_pressed("Ability") and plr.alive:
		Ability()

func Ability():
	pass
