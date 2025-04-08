class_name Shop_Screen
extends Control

@export var menu: Control
var plr:Player
var up1:Upgrade
var up2:Upgrade
var up3:Upgrade
var w1_id
var w2_id
var w3_id
var w1:Node3D
var w2:Node3D
var w3:Node3D
@export_group("buttons")
@export_subgroup("weapon buttons")
@export var w_button1:Weapon_Button
@export var w_button2:Weapon_Button
@export var w_button3:Weapon_Button
@export_subgroup("ability buttons")
@export var up_button1:Upgrade_Button
@export var up_button2:Upgrade_Button
@export var up_button3:Upgrade_Button
@export_group("")
@export var money_label:RichTextLabel
@export var item_icon:TextureRect
var randomized=false
var selected_weapon_id:int
var econom:Player_Economy_Manager
var has_selected=false
var selected
var selected_button:Button
var start=true

func _process(_delta):
	if econom==null:econom=get_tree().get_first_node_in_group("Economy")
	elif econom!=null: money_label.text=str(econom.money)
	
	if start and plr != null:#FIXME wont reset when changing room
		rand_upgrades()
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

func _on_exit_button_pressed():
	toggle_menu(false)
	econom=get_tree().get_first_node_in_group("Economy") 
	if econom is Player_Economy_Manager:
		econom.hide_money()
	plr.show_cursor = false
	plr.disabled=false
	plr.in_dialogue=false
	plr.can_move=true

func rand_upgrades():
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	while(true):
		up1=plr.upgrade_manager.available_upgrade.pick_random()
		up2=plr.upgrade_manager.available_upgrade.pick_random()
		up3=plr.upgrade_manager.available_upgrade.pick_random()
		if up1!=up3 and up2!=up3 and up1!=up2:
			up_button1.up_object=up1
			up_button1.disabled=false
			up_button2.up_object=up2
			up_button2.disabled=false
			up_button3.up_object=up3
			up_button3.disabled=false
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
			w_button1.w_object=w1
			w_button1.weapon=plr.upgrade_manager.weapon_manager.available_weapons[w1_id]
			w_button1.plr=plr
			w_button1.disabled=false
			
			w_button2.w_object=w2
			w_button2.weapon=plr.upgrade_manager.weapon_manager.available_weapons[w2_id]
			w_button2.plr=plr
			w_button2.disabled=false
			
			w_button3.w_object=w3
			w_button3.weapon=plr.upgrade_manager.weapon_manager.available_weapons[w3_id]
			w_button3.plr=plr
			w_button3.disabled=false
			
			print(str(plr.upgrade_manager.weapon_manager.available_weapons[w1_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[w2_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[w3_id].name))
			break

func _on_weapon_2_select_button_pressed():
	var econom=get_tree().get_first_node_in_group("Economy")
	if econom is Player_Economy_Manager:
		if selected and (econom.money-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)>=0:
			econom.increase_money(-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)
			print(str(-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)+" money")
			plr.upgrade_manager.weapon_manager.change_weapon_2(selected_weapon_id)
			has_selected=false
			selected=null
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
			has_selected=false
			selected=null
		elif selected and (econom.money-plr.upgrade_manager.weapon_manager.available_weapons[selected_weapon_id].price)<0:
			print("ur broke")
			#TODO play insufficient fund sound effect
		elif !selected:
			print("select a weapon, dammit!")
