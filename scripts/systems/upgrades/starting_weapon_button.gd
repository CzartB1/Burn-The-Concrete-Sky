class_name Starting_Weapon_Button
extends Button

var plr:Player
@export var icon_:TextureRect
@export var label:RichTextLabel
@export var descriptor:RichTextLabel
var start_screen:Starting_Weapon_Screen
var weapon_id:int

func _process(delta):
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	label.text="[center]"+str(plr.upgrade_manager.weapon_manager.available_weapons[weapon_id].name)
	icon_.texture=plr.upgrade_manager.weapon_manager.available_weapons[weapon_id].icon

func _on_pressed():
	start_screen.selected_weapon_id=weapon_id
	start_screen.selected=true
	#print(str(plr.upgrade_manager.equipped_upgrade))
	start_screen.weapon=true
	descriptor.text="[center]"+plr.upgrade_manager.weapon_manager.available_weapons[weapon_id].Description
