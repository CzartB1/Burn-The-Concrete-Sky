class_name Boss_Room
extends Node3D

@export var start_pos: Node3D
@export var manager:Room_manager
@export var entrance: Node3D
@export var boss_scene: PackedScene
var boss: Enemy
@export var boss_spawn: Node3D
@export var nav:NavigationRegion3D
@export_group("music")
@export var boss_music:AudioStream
var group:Combat_Group
var started=false
var finished=false
var vis_demolock=false
var plr
var shwn=false

func _ready():
	entrance.visible = false
	entrance.process_mode = Node.PROCESS_MODE_DISABLED
	if nav!=null: nav.enabled=false

func _process(delta):
	if !started: return
	if boss==null and !finished:
		boss_killed()
	if vis_demolock:
		manager.demo_lock_screen.process_mode=Node.PROCESS_MODE_INHERIT
		if !shwn:
			manager.demo_lock_screen.show_anim()
			shwn=true

func move_player_to_spawn():
	plr = get_tree().get_first_node_in_group("Player")
	plr.global_position = start_pos.global_position

func change_level():
	manager.randomize_room()

func _on_trigger_body_entered(body):
	if !started and body is Player and visible:
		game_manager.in_battle=true
		nav.enabled=true
		started = true
		entrance.visible = true
		entrance.process_mode = Node.PROCESS_MODE_INHERIT
		
		var instance = boss_scene.instantiate()
		get_tree().get_root().add_child(instance)
		boss=instance
		
		#await get_tree().create_timer(1).timeout
		instance.global_position = boss_spawn.global_position
		instance.global_rotation_degrees = boss_spawn.global_rotation_degrees
		
		#if boss_music!=null:
			#var music:Music_Manager = get_tree().get_first_node_in_group("Music")
			#music.force_play_music(boss_music)

func boss_killed():
	print("boss defeated")
	var cl=get_tree().get_first_node_in_group("Clear_Screen")
	cl.clear()
	#TODO wait a fucking bit
	#TODO show the clucking mouse goddamint
	if manager.demo_lock_screen!=null and manager.demo_lock: 
		#TODO disable shooting and pausing
		#TODO show stats, maybe leaderboard
		manager.demo_lock_screen.process_mode=Node.PROCESS_MODE_INHERIT
		vis_demolock=true
	elif manager.demo_lock_screen==null or !manager.demo_lock:
		#TODO make animated screen that shows transition to another stage/layer
		#TODO go to another stage's intro room
		manager.next_room_category=2
		manager.randomize_room() #FUUUCK THISSS PIECE OF SHIIIIIT
	game_manager.in_battle=false
	finished=true
	
