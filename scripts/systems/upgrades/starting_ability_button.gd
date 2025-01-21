class_name Starting_Ability_Button
extends Button

var plr:Player
var start_screen:Starting_Weapon_Screen
@export var ability_id:int

func _process(delta):
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	text=str(plr.upgrade_manager.available_upgrade[ability_id].name)

func _on_pressed():
	start_screen.selected_weapon_id=ability_id
	start_screen.selected=true
	#print(str(plr.upgrade_manager.equipped_upgrade))
	start_screen.weapon=false
