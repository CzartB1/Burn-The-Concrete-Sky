class_name Weapon_Screen
extends Control

var plr:Player
@export var menu: Control
var w1_id
var w2_id
var w3_id
var w1:Node3D
var w2:Node3D
var w3:Node3D
@export var w_button1:Weapon_Button
@export var w_button2:Weapon_Button
@export var w_button3:Weapon_Button
var start=true
var selected_weapon_id:int
var has_selected=false
var selected=false
var selected_button:Button
@export var money_label:RichTextLabel
var econom:Player_Economy_Manager

func _process(delta):
	if econom==null:
		econom=get_tree().get_first_node_in_group("Economy")
	money_label.text=str(econom.money)
	
	if start and plr != null:#FIXME wont reset when changing room
		rand_weapons()
		start = false
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")

func toggle_menu(on:bool):
	menu.visible = on
	if on:
		menu.process_mode = Node.PROCESS_MODE_INHERIT
	elif !on:
		menu.process_mode = Node.PROCESS_MODE_DISABLED


func rand_weapons():
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	while(true):
		w1_id = randi_range(0,plr.upgrade_manager.weapon_manager.available_weapons.size()-1)
		w2_id = randi_range(0,plr.upgrade_manager.weapon_manager.available_weapons.size()-1)
		w3_id = randi_range(0,plr.upgrade_manager.weapon_manager.available_weapons.size()-1)
		w1=plr.upgrade_manager.weapon_manager.available_weapons[w1_id]
		w2=plr.upgrade_manager.weapon_manager.available_weapons[w2_id]
		w3=plr.upgrade_manager.weapon_manager.available_weapons[w3_id]
		if w1_id!=w3_id and w2_id!=w3_id and w1_id!=w2_id:
			print(str(w1_id)+", "+str(w2_id)+", "+str(w3_id))
			w_button1.text=str(plr.upgrade_manager.weapon_manager.available_weapons[w1_id].name)+"\nprice: "+str(plr.upgrade_manager.weapon_manager.available_weapons[w1_id].price)
			w_button1.weapon=plr.upgrade_manager.weapon_manager.available_weapons[w1_id]
			w_button1.plr=plr
			w_button1.disabled=false
			w_button1.weapon_screen=self
			w_button2.text=str(plr.upgrade_manager.weapon_manager.available_weapons[w2_id].name)+"\nprice: "+str(plr.upgrade_manager.weapon_manager.available_weapons[w2_id].price)
			w_button2.weapon=plr.upgrade_manager.weapon_manager.available_weapons[w2_id]
			w_button2.plr=plr
			w_button2.disabled=false
			w_button2.weapon_screen=self
			w_button3.text=str(plr.upgrade_manager.weapon_manager.available_weapons[w3_id].name)+"\nprice: "+str(plr.upgrade_manager.weapon_manager.available_weapons[w3_id].price)
			w_button3.weapon=plr.upgrade_manager.weapon_manager.available_weapons[w3_id]
			w_button3.plr=plr
			w_button3.disabled=false
			w_button3.weapon_screen=self
			print(str(plr.upgrade_manager.weapon_manager.available_weapons[w1_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[w2_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[w3_id].name))
			break

func _on_weapon_2_select_button_pressed():
	var econom=get_tree().get_first_node_in_group("Economy")
	if econom is Player_Economy_Manager:
		if selected and (econom.money-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)>=0:
			econom.increase_money(-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)
			print(str(-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)+" money")
			plr.upgrade_manager.weapon_manager.change_weapon_2(selected_weapon_id)
			has_selected=true
			toggle_menu(false)
			plr.show_cursor = false
			plr.disabled=false
			if selected_button!=null:
				selected_button.disabled=true
			#body.queue_free() 
		elif selected and (econom.money-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)<0:
			print("ur broke")
			#TODO play insufficient fund sound effect
		elif !selected:
			print("select a weapon, dammit!")


func _on_weapon_1_select_button_pressed():
	var econom=get_tree().get_first_node_in_group("Economy")
	if econom is Player_Economy_Manager: 
		if selected and (econom.money-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)>=0:
			econom.increase_money(-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)
			print(str(-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)+" money")
			plr.upgrade_manager.weapon_manager.change_weapon_1(selected_weapon_id)
			has_selected=true
			toggle_menu(false)
			plr.show_cursor = false
			plr.disabled=false
			if selected_button!=null:
				selected_button.disabled=true
			#body.queue_free() 
		elif selected and (econom.money-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)<0:
			print("ur broke")
			#TODO play insufficient fund sound effect
		elif !selected:
			print("select a weapon, dammit!")


func _on_exit_button_pressed():
	toggle_menu(false)
	plr.show_cursor = false
	plr.disabled=false
