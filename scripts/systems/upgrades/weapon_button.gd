class_name Weapon_Button
extends Button

var plr:Player
var weapon_screen:Weapon_Screen
@export var weapon_id:int
var weapon

func _process(delta): 
	if plr==null: plr=get_tree().get_first_node_in_group("Player")
	# FIXME_ disable disable when not choosing this weapon
	#if weapon_screen.selected_weapon_id!=null:
		#if weapon_screen.selected_weapon_id!=plr.upgrade_manager.weapon_manager.available_weapons.find(weapon):
			#disabled=false

func _on_pressed():
	#if plr!=null:
	weapon_screen.selected_weapon_id=plr.upgrade_manager.weapon_manager.available_weapons.find(weapon)
	weapon_screen.selected=true
	print(str(plr.upgrade_manager.equipped_upgrade))
	weapon_screen.selected_button=self
	#disabled=true
