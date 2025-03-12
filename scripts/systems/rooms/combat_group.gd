class_name Combat_Group
extends Node3D

@export var rooms: Array[Room]
@export var commons: Array[PackedScene]
@export var elites: Array[PackedScene]
@export var manager:Room_manager
var prev_combat_id
@export var enabled = false
@export var next_group:Array[Combat_Group]
@export var room_amount:int=4
@export_group("Special Rooms")
@export var intro_room: Room
@export var rest_room: Room
@export var preboss_room: Room
@export var boss_room: Boss_Room
var last_room: Room

func _ready():
	if intro_room!=null:
		intro_room.visible=false
		intro_room.process_mode=Node.PROCESS_MODE_DISABLED
	if rest_room!=null:
		rest_room.visible=false
		rest_room.process_mode=Node.PROCESS_MODE_DISABLED
	if preboss_room!=null:
		preboss_room.visible=false
		preboss_room.process_mode=Node.PROCESS_MODE_DISABLED
	if boss_room!=null:
		boss_room.group = self
		boss_room.visible=false
		boss_room.process_mode=Node.PROCESS_MODE_DISABLED

func _process(_delta):
	manager.current_combatgroup=self
	for ro in rooms:
		if ro.spawner!=null:
			ro.spawner.enemies=commons
			ro.spawner.elites=elites
		if ro.manager==null and manager!=null:
			ro.manager=manager
	if enabled:
		if !rooms[manager.current_room].active:
			rooms[manager.current_room].active = true
			rooms[manager.current_room].spawner.enemies=commons
			rooms[manager.current_room].spawner.elites=elites
		if intro_room!=null and manager.intro_room!=intro_room:
			manager.intro_room=intro_room
		if rest_room!=null and manager.rest_room!=rest_room:
			manager.rest_room=rest_room
		if boss_room!=null and manager.rest_room!=boss_room:
			manager.boss_room=boss_room
			boss_room.manager=manager
	elif !enabled:
		for ro in rooms:
			ro.visible = false
			ro.process_mode = Node.PROCESS_MODE_DISABLED
	for i in get_children():
		if i is Room: i.combat_group=self

func choose_room():
	print("choosing combat room")
	enabled=true
	manager.current_room = randi_range(0,rooms.size()-1)
	
	if manager.current_room == prev_combat_id or rooms[manager.current_room]==last_room:
		while manager.current_room == prev_combat_id or rooms[manager.current_room]==last_room:
			manager.current_room = randi_range(0,rooms.size()-1)
			if manager.current_room != prev_combat_id and rooms[manager.current_room]!=last_room:
				check_room()
				print("combat room id: "+str(manager.current_room))
				await get_tree().create_timer(0.1).timeout
				manager.changing_rooms = false
				prev_combat_id=manager.current_room
				last_room=rooms[manager.current_room]
				break
	elif prev_combat_id==null or manager.current_room != prev_combat_id or rooms[manager.current_room]!=last_room:
		print("combat room id: "+str(manager.current_room))
		check_room()
		await get_tree().create_timer(0.1).timeout
		manager.changing_rooms = false
		prev_combat_id=manager.current_room
		last_room=rooms[manager.current_room]

func check_room():
	manager.clear_abilities()
	enabled=true
	if prev_combat_id==null:
		manager.current_room = randi_range(0,rooms.size()-1)
		prev_combat_id=manager.current_room
		last_room=rooms[manager.current_room]
	for i in rooms.size():
		rooms[i].spawner.reset_spawner()
		if i == manager.current_room:
			print("moving plr"+str(i))
			rooms[i].navmesh.enabled=true
			rooms[i].visible = true
			rooms[i].process_mode = Node.PROCESS_MODE_INHERIT
			rooms[i].move_player_to_spawn()
			#manager.room_count+=1
			print("room "+ str(manager.room_count) +" combat || id: "+str(i))
			if rooms[i].spawner!=null:
				rooms[i].spawner.enemies=commons
				rooms[i].spawner.elites=elites
		elif i != manager.current_room:
			rooms[i].navmesh.enabled=false
			rooms[i].visible = false
			rooms[i].process_mode = Node.PROCESS_MODE_DISABLED
	if manager.room_count==room_amount: 
		if manager.next_room_category==4 or manager.current_room_category==4:
			enable_boss_room()
		else:
			if boss_room==null:
				manager.next_room_category=2 #change to intro
				#rest_room.move_player_to_spawn()
				#manager.room_count=0
				#rest becomes intro
			elif boss_room!=null:
				manager.next_room_category=3
		
	else:
		manager.next_room_category=1 #to another combat
	var tr=get_tree().get_first_node_in_group("Transition")
	tr.play("fade_in")

func disable_group():
	for room in rooms:
		room.visible=false
		room.process_mode=Node.PROCESS_MODE_DISABLED

func enable_rest_room():
	rest_room.visible = true
	rest_room.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().create_timer(0.05).timeout
	rest_room.move_player_to_spawn()
	#print("here=========")
	if rest_room.shopkeepers.size()>0:
		for i in rest_room.shopkeepers: i.rand_upgrades()

func enable_preboss_room():
	preboss_room.visible = true
	preboss_room.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().create_timer(0.05).timeout
	preboss_room.move_player_to_spawn()
	#print("here=========")
	if preboss_room.shopkeepers.size()>0:
		for i in preboss_room.shopkeepers: i.rand_upgrades()

func enable_boss_room():
	for room in rooms:
		room.spawner.reset_spawner()
	boss_room.move_player_to_spawn()
	boss_room.visible = true
	boss_room.process_mode = Node.PROCESS_MODE_INHERIT

func disable_rest_room():
	rest_room.visible = false
	rest_room.process_mode = Node.PROCESS_MODE_DISABLED

func disable_preboss_room():
	preboss_room.visible=false
	preboss_room.process_mode=Node.PROCESS_MODE_DISABLED

func activate_next_group():
	manager.clear_abilities()
	#TODO instead of having all groups active all at once, instantiate the next one, and delete the old one to free up memory
	var chos=next_group.pick_random()
	manager.combatgroup=chos
	chos.enabled=true
	enabled=false
	#TODO go to intro instead of combat
	for oa in chos.rooms:
		oa.spawner.reset_spawner()
	for ro in rooms:
		ro.visible = false
		ro.process_mode = Node.PROCESS_MODE_DISABLED
		ro.navmesh.enabled=false
	if boss_room!=null:
		boss_room.visible=false
		boss_room.process_mode=Node.PROCESS_MODE_DISABLED
	#visible=false
	#process_mode = Node.PROCESS_MODE_DISABLED
	print("Group chosen: " + str(chos.name))
	print("changing combat group")

func activate_group(chos:Combat_Group):
	if manager.current_room_category==2:manager.leave_intro()
	manager.can_change=true
	manager.clear_abilities()
	manager.combatgroup=chos
	enabled=false
	for oa in chos.rooms:
		oa.spawner.reset_spawner()
	if intro_room: 
		intro_room.visible = false
		intro_room.process_mode = Node.PROCESS_MODE_DISABLED
	for ro in rooms:
		ro.visible = false
		ro.process_mode = Node.PROCESS_MODE_DISABLED
		ro.navmesh.enabled=false
	if boss_room!=null:
		boss_room.visible=false
		boss_room.process_mode=Node.PROCESS_MODE_DISABLED
	#visible=false
	#process_mode = Node.PROCESS_MODE_DISABLED
	print("Group chosen: " + str(chos.name))
	print("changing combat group")

func activate_selected_room(room_id:int):
	manager.current_room = room_id
	#manager.can_change=true
	check_room()
	print("combat room id: "+str(manager.current_room))
	await get_tree().create_timer(0.1).timeout
	manager.changing_rooms = false
	prev_combat_id=manager.current_room
	last_room=rooms[manager.current_room]
