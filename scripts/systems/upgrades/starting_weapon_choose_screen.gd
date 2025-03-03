class_name Starting_Weapon_Screen
extends Control

var plr:Player
@export var menu: Control
@export var body:Node3D
var w1_id
var w2_id
var a1_id
var a2_id
var w1:Node3D
var w2:Node3D
var a1:Upgrade
var a2:Upgrade
@export var w_button1:Starting_Weapon_Button
@export var w_button2:Starting_Weapon_Button
@export var a_button1:Starting_Ability_Button
@export var a_button2:Starting_Ability_Button
var start=true
var selected_weapon_id:int
var has_selected=false
var selected=false
var weapon=false
var randomized=false

func _ready():
	print("ya")

func _process(delta):
	var sc = get_tree().get_nodes_in_group("weapon_screen")
	if sc.size()>1:
		for s in sc:
			if s!=get_tree().get_first_node_in_group("weapon_screen"):s.queue_free()
	if has_selected:queue_free()
	if start and plr != null:
		#rand_weapons()
		start = false
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")

func toggle_menu(on:bool):
	menu.visible = on
	if on:
		menu.process_mode = Node.PROCESS_MODE_ALWAYS
	elif !on:
		menu.process_mode = Node.PROCESS_MODE_DISABLED

func _on_button_pressed():
	toggle_menu(false)
	plr.show_cursor = false
	plr.disabled=false
	body.queue_free()
	queue_free()

func rand_weapons():
	if randomized or has_selected: return
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	while(true):  
		w1_id = randi_range(0,plr.upgrade_manager.weapon_manager.available_weapons.size()-1)
		w2_id = randi_range(0,plr.upgrade_manager.weapon_manager.available_weapons.size()-1)
		a1_id = randi_range(0,plr.upgrade_manager.available_upgrade.size()-1)
		a2_id = randi_range(0,plr.upgrade_manager.available_upgrade.size()-1)
		w1=plr.upgrade_manager.weapon_manager.available_weapons[w1_id]
		w2=plr.upgrade_manager.weapon_manager.available_weapons[w2_id]
		a1=plr.upgrade_manager.available_upgrade[a1_id]
		a2=plr.upgrade_manager.available_upgrade[a2_id]
		if w1_id!=w2_id and a1_id!=a2_id:
			#print(str(w1_id)+", "+str(w2_id)+", "+str(w3_id))
			#w_button1.text=str(plr.upgrade_manager.weapon_manager.available_weapons[w1_id].name)
			w_button1.weapon_id=w1_id
			w_button1.plr=plr
			w_button1.disabled=false
			w_button1.start_screen=self
			#w_button2.text=str(plr.upgrade_manager.weapon_manager.available_weapons[w2_id].name)
			w_button2.weapon_id=w2_id
			w_button2.plr=plr
			w_button2.disabled=false
			w_button2.start_screen=self
			#w_button3.text=str(plr.upgrade_manager.weapon_manager.available_weapons[w3_id].name)
			a_button1.ability_id=a1_id
			a_button1.plr=plr
			a_button1.disabled=false
			a_button1.start_screen=self
			
			a_button2.ability_id=a2_id
			a_button2.plr=plr
			a_button2.disabled=false
			a_button2.start_screen=self
			#print(str(plr.upgrade_manager.weapon_manager.available_weapons[w1_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[w2_id].name)+", "+str(plr.upgrade_manager.weapon_manager.available_weapons[w3_id].name))
			randomized=true
			break

func _on_select_pressed():
	if selected:
		has_selected=true
		toggle_menu(false)
		if weapon: plr.upgrade_manager.weapon_manager.change_weapon_2(selected_weapon_id)
		elif !weapon:
			plr.upgrade_manager.available_upgrade[selected_weapon_id].enabled=true
			plr.upgrade_manager.upgrade_availability_check()
		plr.show_cursor = false
		plr.disabled=false
		for i in get_tree().get_nodes_in_group("justicar"):
			i.queue_free()
	elif !selected:
		print("select a weapon, dammit!")
