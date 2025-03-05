class_name Starting_Ability_Button
extends Button

var plr:Player
var start_screen:Starting_Weapon_Screen
@export var ability_id:int
@export var icon_:TextureRect
@export var label:RichTextLabel
@export var descriptor:RichTextLabel

func _process(delta):
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	label.text="[center]"+str(plr.upgrade_manager.available_upgrade[ability_id].name)
	icon_.texture=plr.upgrade_manager.available_upgrade[ability_id].icon

func _on_pressed():
	start_screen.selected_weapon_id=ability_id
	start_screen.selected=true
	#print(str(plr.upgrade_manager.equipped_upgrade))
	start_screen.weapon=false
	descriptor.text="[center]"+plr.upgrade_manager.available_upgrade[ability_id].Description
