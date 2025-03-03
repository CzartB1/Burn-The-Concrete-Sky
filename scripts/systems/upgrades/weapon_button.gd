class_name Weapon_Button
extends Button

var plr:Player
@export var weapon_screen:Shop_Screen
@export var weapon_id:int
@export var button_enable:Control
@export var button_disable:Control
@export var description_box:RichTextLabel
var w_object
var weapon:Node3D


func _process(delta): 
	if plr==null: plr=get_tree().get_first_node_in_group("Player")
	if w_object!=null:
		text=w_object.name + " - " + str(w_object.price)
	# FIXME_ disable disable when not choosing this weapon
	#if weapon_screen.selected_weapon_id!=null:
		#if weapon_screen.selected_weapon_id!=plr.upgrade_manager.weapon_manager.available_weapons.find(weapon):
			#disabled=false

func _on_pressed():
	#if plr!=null:
	if w_object!=null:
		description_box.text=w_object.Description
	weapon_screen.selected_weapon_id=plr.upgrade_manager.weapon_manager.available_weapons.find(weapon)
	weapon_screen.selected=true
	print(str(plr.upgrade_manager.equipped_upgrade))
	weapon_screen.selected_button=self
	button_disable.visible=false
	button_enable.visible=true
	weapon_screen.item_icon.texture=w_object.icon
	#disabled=true
