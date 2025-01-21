class_name Room
extends Node3D

@export var start_pos: Node3D
@export var manager:Room_manager
@export var spawner:enemy_spawner
@export var navmesh:NavigationRegion3D
@export var shopkeepers:Array[Shopkeeper]
var combat_group:Combat_Group
var active = false
var plr
var end:Room_End

func _ready():
	if navmesh!=null:
		navmesh.enabled = false
		print("nav disabled")

func _process(_delta):
	if manager == null:
		print("room no manager")
		var _man = get_tree().get_first_node_in_group("room_manager")
		if _man is Room_manager:
			manager = _man
			print("manager found")
	elif manager != null:
		SaveManager.current_combat_group=manager.combatgroups.find(combat_group)
	
	if navmesh!=null and spawner!=null:
		if spawner.started and !navmesh.enabled and !spawner.finished:
			navmesh.enabled=true
		#elif spawner.finished and navmesh.enabled:
			#navmesh.enabled=false
	
	if active:
		if navmesh!=null:
			navmesh.enabled = true
			#print("nav enabled")
		if spawner!=null:
			manager.current_room_category=1
			if spawner.end!=end: 
				spawner.end=end
				end.can_go=false
		if spawner==null or navmesh==null:
			end.can_go=true

func move_player_to_spawn():
	print("moviing player")
	active=true
	if navmesh!=null:
		navmesh.enabled = true
		print("nav enabled")
	elif navmesh==null:
		print("no navmesh here")
	
	var plr = get_tree().get_first_node_in_group("Player")
	plr.global_position = start_pos.global_position
	if plr is Player:
		plr.cam_holder.reset_cam_position()
		plr.hp=plr.HP_bar.max_value
	print("moving player done")

func change_level():
	reset()
	active = false
	if navmesh!=null:
		navmesh.enabled = false
		print("nav disabled")
	manager.randomize_room()

func reset():
	if spawner!=null:
		spawner.reset_spawner()
	for k in get_tree().get_nodes_in_group("Enemy"): #kill all enemy
		k.queue_free()
	
	for t in get_tree().get_nodes_in_group("temps"): #kill all temporary objects
		t.queue_free()
	
	#for i in shopkeepers: i.rand_upgrades()aaaasssssssssssss
