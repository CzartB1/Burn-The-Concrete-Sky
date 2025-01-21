class_name enemy_spawner
extends Node3D

@export var entrance: Node3D
@export var exits: Array[Node3D]
var started=false
var finished=false
@export var spawners: Array[Node3D]
@export var enemies: Array[PackedScene]
@export var elites: Array[PackedScene]
@export var elites_spawn_delay_probability: Vector2i = Vector2i(1,3)
@export var common_spawn_limit_probability: Vector2i = Vector2i(3,7)
@export var enemy_amount_probability: Vector2i = Vector2i(3,5)
@export var spawn_offset: Vector2=Vector2(2,2)
@onready var spawn_timer = $spawn_timer2
var common_spawn_limit=0
var elites_spawn_delay=0
var elites_amount=1
var elites_start=0
var elites_killed=-1
var common_spawned=0
var plr_pos
var prev_spawn_id=0
var end:Room_End
@onready var sp_delay:Timer = $spawn_delay

func _ready(): #FIXME make some zone under the levels where enemies and players instantly dies
	entrance.visible = false
	entrance.process_mode = Node.PROCESS_MODE_DISABLED
	elites_spawn_delay=randi_range(elites_spawn_delay_probability.x,elites_spawn_delay_probability.y)
	common_spawn_limit=randi_range(common_spawn_limit_probability.x,common_spawn_limit_probability.y)
	
	for i in exits.size():
		exits[i].visible=false
		exits[i].process_mode=Node.PROCESS_MODE_DISABLED

func _process(_delta):
	if started: plr_pos = get_tree().get_first_node_in_group("Player").global_position
	if elites_killed==elites_start and started and common_spawned<=0:
		if !finished: #FIX ME room clears when there are commons still left.
			print("Room cleared")
			var cl=get_tree().get_first_node_in_group("Clear_Screen")
			#var econom:Player_Economy_Manager=get_tree().get_first_node_in_group("Economy")
			game_manager.stat_roomcleared+=1
			cl.clear()
			#econom.mult_reset()
			#econom.hide_money()
			#econom.hide_mult()
			end.can_go=true
		game_manager.in_battle=false
		finished=true
		for i in exits.size():
			exits[i].visible=false
			exits[i].process_mode=Node.PROCESS_MODE_DISABLED


func _on_trigger_body_entered(body):
	if !started and body is Player and visible:
		elites_amount=randi_range(enemy_amount_probability.x,enemy_amount_probability.y)
		elites_start=elites_amount
		elites_killed=0
		print(str(elites_amount)+" enemies will be spawned")
		
		entrance.visible = true
		entrance.process_mode = Node.PROCESS_MODE_ALWAYS
		for i in exits.size():
			exits[i].visible=true
			exits[i].process_mode=Node.PROCESS_MODE_ALWAYS
		game_manager.in_battle=true
		sp_delay.start()


func _on_spawn_timer_timeout(): # spawn enemy here
	#if elites_amount <= 0: return
	var en_id = randi_range(0,enemies.size()-1)
	var el_id = randi_range(0,elites.size()-1)
	while true:
		var sp_id = randi_range(0,spawners.size()-1)
		var sp_off = Vector3(randf_range(spawn_offset.x,-spawn_offset.x),0,randf_range(spawn_offset.y,-spawn_offset.y))
		if common_spawned<common_spawn_limit:#common spawn
			var instance = enemies[en_id].instantiate()
			get_tree().get_root().add_child(instance)
			instance.global_position = spawners[sp_id].global_position + sp_off
			instance.rotation_degrees = spawners[sp_id].global_rotation_degrees
			prev_spawn_id = sp_id
			if instance is Enemy: 
				instance.spawner = self
				instance.elite=false
			common_spawned+=1
			elites_spawn_delay-=1
			if common_spawned<common_spawn_limit: spawn_timer.start()
		elif common_spawned>=common_spawn_limit:
			#print("common enemy limit")
			if elites_amount > 0: #elites spawn
				var instance = elites[el_id].instantiate()
				get_tree().get_root().add_child(instance)
				instance.global_position = spawners[sp_id].global_position + sp_off
				instance.rotation_degrees = spawners[sp_id].global_rotation_degrees
				prev_spawn_id = sp_id
				if instance is Enemy: 
					instance.spawner = self
					instance.elite=true
				elites_amount-=1
				elites_spawn_delay=randi_range(elites_spawn_delay_probability.x,elites_spawn_delay_probability.y)
				if elites_amount>0: spawn_timer.start()
		if elites_amount <= 0: break

func reset_spawner():
	started=false
	finished = false
	elites_killed=0
	elites_amount = elites_start
	entrance.visible = false
	entrance.process_mode = Node.PROCESS_MODE_DISABLED
	elites_spawn_delay=randi_range(elites_spawn_delay_probability.x,elites_spawn_delay_probability.y)
	common_spawn_limit=randi_range(common_spawn_limit_probability.x,common_spawn_limit_probability.y)
	for i in exits.size():
		exits[i].visible=false
		exits[i].process_mode=Node.PROCESS_MODE_DISABLED


func _on_spawn_delay_timeout():
	spawn_timer.start()
	started = true
