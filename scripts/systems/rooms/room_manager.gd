class_name Room_manager
extends Node3D

#@export var combat_rooms: Array[Room]
@export var intro_room: Room
@export var rest_room: Room
@export var boss_room: Boss_Room
@export var current_room:int
@export_range(0,4) var next_room_category:int = 0 #0=intro;1=combat;2=rest;3=pre-boss rest;4=boss 
@export var boss_count = 6 #when it's time for the boss fight
@export var combatgroup: Combat_Group
@export var combatgroups: Array[Combat_Group]
@export_group("Demo")
@export var demo_lock: bool=false
@export var demo_lock_screen: Control
@export_group("Transition")
@export var transition_screen: ColorRect
var current_room_category:int
var current_combatgroup: Combat_Group #TODO make rooms set the current group with their group
var cur_room_obj
var plr: Player
var intro = true
var room_count = 0
var changing_rooms = false
var prev_combat_id
var upgrading = false
var faded=false
var can_change=true
var preboss:Room
var started=false

func _ready():
	intro_room=combatgroup.intro_room
	boss_room.manager=self
	intro_room.manager = self
	rest_room.manager = self
	if preboss!=null:preboss.manager=self
	go_to_intro()
	
	if demo_lock_screen!= null:
		if !demo_lock: demo_lock_screen.queue_free()
		elif demo_lock:
			demo_lock_screen.process_mode=Node.PROCESS_MODE_DISABLED
	#for i in combat_rooms.size(): #disable combat room
		#combat_rooms[i].manager = self
	disable_combat_rooms()
	disable_rest_room()
	disable_boss()

func _process(_delta):
	if plr == null:
		var plr_check = get_tree().get_first_node_in_group("Player")
		if plr_check is Player:
			plr = plr_check
	var plrs:Array=get_tree().get_nodes_in_group("Player")
	if plrs.size()>1:
		for i in plrs.size()-1:
			if i!=0:
				plrs[i].queue_free()
	
	if !faded and transition_screen.self_modulate.a>0 and started:
		var tr=get_tree().get_first_node_in_group("Transition")
		tr.play("fade_in")
	
	if next_room_category == 1: 
		# the duct tape for the room 2 (room with id: 1) navigation problem
		# in case the room_check() didn;t activate the navigation, this activates it
		if !combatgroup.rooms[current_room].active:
			combatgroup.rooms[current_room].active = true
			print("There may have been an error in the room manager, Applying backup...")
	
	for i in combatgroups:
		if i == combatgroup:
			i.enabled=true
		elif i != combatgroup:
			if i:i.enabled=false
			elif !i:combatgroups.erase(i)

func randomize_room(): # this was (and kinda still is) basically a big-ass RNG checking machine
	if !can_change: return
	var tr=get_tree().get_first_node_in_group("Transition")
	can_change=false
	if !faded: 
		tr.play("fade_out") #FIX ME make some kind of bool that checks if it's faded or not
		faded=true
	await get_tree().create_timer(.01).timeout
	if !changing_rooms: 
		changing_rooms=true
		if intro: 
			leave_intro()
			check_room()
			await get_tree().create_timer(0.1).timeout
			changing_rooms = false
			prev_combat_id=current_room
		elif !intro and next_room_category==1: #to combat
			leave_intro()
			disable_rest_room()
			room_count+=1
			for ro in combatgroup.next_group:
				for oa in ro.rooms: 
					oa.spawner.reset_spawner()
					#I spent several fucking hours, totally sleepy, trying to fix an invisible collider
					#SO, this is the fucking fix???
					#Update: This only works if the starting group is test_cg1 T-T
				combatgroup.choose_room()
		elif !intro and next_room_category==2: # to intro
			combatgroup.activate_next_group()
			check_room()
			await get_tree().create_timer(0.1).timeout
			changing_rooms = false
		elif !intro and next_room_category==3: # to pre-boss
			check_room()
			await get_tree().create_timer(0.1).timeout
			changing_rooms = false
		elif !intro and next_room_category==4: # to boss
			check_room()
			await get_tree().create_timer(0.1).timeout
			changing_rooms = false

func check_room(): # This basically enables and disables shit, and also change category
	if !changing_rooms: return
	clear_abilities()
	if next_room_category == 1: # combat
		current_room_category=1
		leave_intro()
		disable_rest_room()
		room_count+=1
		#if room_count>=combatgroup.room_amount: combatgroup.activate_next_group()
		combatgroup.check_room()
	elif next_room_category == 2: # intro/rest
		current_room_category=2
		disable_combat_rooms()
		room_count+=1
		go_to_intro()
		for s in intro_room.shopkeepers:
			s.rand_upgrades()
		intro_room.move_player_to_spawn()
		next_room_category=1
		room_count=0
		print("room "+ str(room_count) +" || type: rest")
	elif next_room_category == 3: # pre-boss
		current_room_category=3
		disable_combat_rooms()
		go_to_preboss() #FIXME for some reason, scumtown will usse factory's preboss
		for s in combatgroup.preboss_room.shopkeepers:
			s.rand_upgrades()
		combatgroup.preboss_room.move_player_to_spawn()
		next_room_category=4
		print("room "+ str(room_count) +" || type: pre-boss")
	elif next_room_category == 4: # boss
		current_room_category=4
		combatgroup.check_room()
		disable_combat_rooms()
		next_room_category=2
		print("room "+ str(room_count) +" || type: boss")
	var tr=get_tree().get_first_node_in_group("Transition")
	if !started:started=true
	tr.play("fade_in")
	faded=false

func leave_intro():
	intro = false
	intro_room.visible = false
	intro_room.process_mode = Node.PROCESS_MODE_DISABLED
	next_room_category=1 # always makes it that after intro, it's always combat

func go_to_intro():
	combatgroup.intro_room.visible = true
	combatgroup.intro_room.process_mode = Node.PROCESS_MODE_INHERIT

func go_to_preboss():
	combatgroup.preboss_room.visible = true
	combatgroup.preboss_room.process_mode = Node.PROCESS_MODE_INHERIT

func disable_combat_rooms():
	for i in combatgroups:
		if i:i.disable_group()

func disable_rest_room():
	rest_room.visible = false
	rest_room.process_mode = Node.PROCESS_MODE_DISABLED
	for i in combatgroups:
		if i:i.disable_rest_room()

func leave_pre_boss():
	rest_room.visible = false
	rest_room.process_mode = Node.PROCESS_MODE_DISABLED
	next_room_category=4
	
func disable_boss():
	boss_room.visible = false
	boss_room.process_mode = Node.PROCESS_MODE_DISABLED
	#current_room_category=4

func start():
	intro_room.move_player_to_spawn()

func go_to_next_room():
	randomize_room()

func clear_abilities():
	game_manager.clean_effects()
	var abilts = get_tree().get_nodes_in_group("Abilities")
	if abilts!=null:
		for ab in abilts:
			ab.queue_free()

func select_room(room_id:int=0,category:int=0,combat_group_id:int=0): #HACK add spawner (enemy spawner) tag to rooms in cg2 and cg3
	game_manager.kill_all_enemies()
	game_manager.clean_effects()
	clear_abilities()
	room_count-=1 #room count increases when loadingm id game for some ungodly fucking reason
	for j in combatgroups:
		j.disable_group()
	combatgroup=combatgroups[combat_group_id] 
	print(str(combat_group_id))
	print ("category: "+str(category))
	for room in combatgroup.rooms:
		room.spawner.reset_spawner()
	if category==0: #intro
		intro=true
		go_to_intro()
		disable_combat_rooms()
		disable_rest_room()
		disable_boss()
		intro_room.move_player_to_spawn()
	elif category==1: #combat
		disable_boss()
		leave_intro()
		disable_rest_room()
		for ro in combatgroup.next_group:
			for oa in ro.rooms: 
				oa.spawner.reset_spawner()
			combatgroup.activate_selected_room(room_id)
			await get_tree().create_timer(0.05).timeout
			combatgroup.rooms[room_id].move_player_to_spawn()
	elif category==2: #rest
		room_count=4
		intro = false
		intro_room.visible = false
		intro_room.process_mode = Node.PROCESS_MODE_DISABLED
		disable_boss()
		disable_combat_rooms()
		await get_tree().create_timer(0.05).timeout
		combatgroup.enable_rest_room()
		combatgroup.rest_room.move_player_to_spawn()
		next_room_category=1
		combatgroup.activate_next_group()
	elif category==3: #preboss
		room_count=8
		intro = false
		intro_room.visible = false
		intro_room.process_mode = Node.PROCESS_MODE_DISABLED
		disable_combat_rooms()
		await get_tree().create_timer(0.05).timeout
		combatgroup.enable_rest_room()
		combatgroup.rest_room.move_player_to_spawn()
		next_room_category=4
	elif category==4: #boss
		for room in combatgroup.rooms:
			room.spawner.reset_spawner()
		intro = false
		intro_room.visible = false
		intro_room.process_mode = Node.PROCESS_MODE_DISABLED
		disable_combat_rooms()
		disable_rest_room()
		boss_room.move_player_to_spawn()
		boss_room.visible = true
		boss_room.process_mode = Node.PROCESS_MODE_INHERIT
		next_room_category=2
	
	#to despawn enemy and disable spawner
	#for some mind-melting reason, there might be >1 spawners in one instance when loading in the middle of a combat room
	#that's the reason for disabling an entire fkn array instead of a single node
	
	game_manager.kill_all_enemies()
	var res = get_tree().get_nodes_in_group("spawner")
	for a in res:
		if a is enemy_spawner:a.reset_spawner()
	var tr=get_tree().get_first_node_in_group("Transition")
	tr.play("fade_in")

func stage_change():
	#TODO change intro to stage intro
	
	#TODO change combat group with intro on
	disable_boss()
	disable_combat_rooms()
	room_count+=1
	if rest_room==combatgroup.rest_room:
		combatgroup.enable_rest_room()
	elif rest_room!=combatgroup.rest_room:
		rest_room.visible = true
		rest_room.process_mode = Node.PROCESS_MODE_INHERIT
		rest_room.move_player_to_spawn()
		if rest_room.shopkeeper!=null:
			rest_room.shopkeeper.rand_upgrades()
	combatgroup.activate_next_group()
	pass
