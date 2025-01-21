class_name Upgrade_Menu
extends Control

@export var menu: Control
var plr:Player
var up1_id:int
var up2_id:int
var up3_id:int
var up1:Upgrade
var up2:Upgrade
var up3:Upgrade
@export var up_button1:Upgrade_Button
@export var up_button2:Upgrade_Button
@export var up_button3:Upgrade_Button
@export var money_label:RichTextLabel
var econom:Player_Economy_Manager
var selected_weapon_id:int
var has_selected=false
var selected
var selected_button:Button
var start=true

func _process(_delta):
	if econom==null:
		econom=get_tree().get_first_node_in_group("Economy")
	money_label.text=str(econom.money)
	
	if start and plr != null:#FIXME wont reset when changing room
		rand_upgrades()
		start = false
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")

func toggle_menu(on:bool):
	menu.visible = on
	if on:
		menu.process_mode = Node.PROCESS_MODE_INHERIT
	elif !on:
		menu.process_mode = Node.PROCESS_MODE_DISABLED

func _on_exit_button_pressed():
	econom=get_tree().get_first_node_in_group("Economy") 
	if econom is Player_Economy_Manager:
		econom.hide_money()
	toggle_menu(false)
	plr.show_cursor = false
	plr.disabled=false

func rand_upgrades():
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	while(true):
		#up1_id = randi_range(0,plr.upgrade_manager.available_upgrade.size()-1)
		#up2_id = randi_range(0,plr.upgrade_manager.available_upgrade.size()-1)
		#up3_id = randi_range(0,plr.upgrade_manager.available_upgrade.size()-1)
		up1=plr.upgrade_manager.available_upgrade.pick_random()
		up2=plr.upgrade_manager.available_upgrade.pick_random()
		up3=plr.upgrade_manager.available_upgrade.pick_random()
		if up1!=up3 and up2!=up3 and up1!=up2:
			#print(str(up1_id)+", "+str(up2_id)+", "+str(up3_id))
			#up_button1.text=str(plr.upgrade_manager.weapon_manager.available_weapons[up1_id].name)+"\nprice: "+str(plr.upgrade_manager.weapon_manager.available_weapons[w1_id].price)
			up_button1.up_object=up1
			up_button1.disabled=false
			#up_button2.text=str(plr.upgrade_manager.weapon_manager.available_weapons[up2_id].name)+"\nprice: "+str(plr.upgrade_manager.weapon_manager.available_weapons[w2_id].price)
			up_button2.up_object=up2
			up_button2.disabled=false
			#up_button3.text=str(plr.upgrade_manager.weapon_manager.available_weapons[up3_id].name)+"\nprice: "+str(plr.upgrade_manager.weapon_manager.available_weapons[w3_id].price)
			up_button3.up_object=up3
			up_button3.disabled=false
			#print(str(plr.upgrade_manager.weapon_manager.available_weapons[up1_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[up2_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[up3_id].name))
			break

func _on_buy_button_pressed(): #FIXME Shop error, prob bcs of stage overhaul
	if !has_selected: return
	selected.enabled=true
	econom.increase_money(-selected_button.price)
	print(str(-selected_button.price)+" money")
	plr.upgrade_manager.upgrade_availability_check()
	selected_button.disabled=true
	selected=null
	has_selected=false
	print(str(plr.upgrade_manager.equipped_upgrade))
