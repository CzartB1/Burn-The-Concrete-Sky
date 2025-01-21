extends Node

var save_path = "user://save_game.save"

var next_room_category:int
var current_room_category:int
var current_room_id:int
var current_combat_group:int
var current_room_count:int
var loading_save=false

func save():
	var save_game = FileAccess.open(save_path, FileAccess.WRITE)
	#ch=var_to_bytes_with_objects(game_manager.char_selection)
	save_game.store_var(next_room_category) # HACK connect this to room manager or smth
	save_game.store_var(current_room_category)
	save_game.store_var(current_room_id)
	save_game.store_var(current_combat_group)
	save_game.store_var(current_room_count)
	save_game.store_var(game_manager.current_char_id)
	save_game.store_var(game_manager.stat_highestmult)
	save_game.store_var(game_manager.stat_kills)
	save_game.store_var(game_manager.stat_moneyearned)
	save_game.store_var(game_manager.stat_roomcleared)
	save_game.store_var(game_manager.stat_starttime)
	save_game.store_var(game_manager.stat_timenow)
	#TODO save player abilities and loadout


func load_save(): #FIXME disable enemy spawning
	if FileAccess.file_exists(save_path):
		game_manager.kill_all_enemies()
		loading_save=true
		var file = FileAccess.open(save_path,FileAccess.READ)
		next_room_category=file.get_var(next_room_category)
		current_room_category=file.get_var(current_room_category)
		current_room_id=file.get_var(current_room_id)
		current_combat_group=file.get_var(current_combat_group)
		current_room_count=file.get_var(current_room_count)
		game_manager.current_char_id=file.get_var(game_manager.current_char_id)
		game_manager.stat_highestmult=file.get_var(game_manager.stat_highestmult)
		game_manager.stat_kills=file.get_var(game_manager.stat_kills)
		game_manager.stat_moneyearned=file.get_var(game_manager.stat_moneyearned)
		game_manager.stat_roomcleared=file.get_var(game_manager.stat_roomcleared)
		game_manager.stat_starttime=file.get_var(game_manager.stat_starttime)
		game_manager.stat_timenow=file.get_var(game_manager.stat_timenow)
		
		await get_tree().create_timer(0.01).timeout
		
		var plr=get_tree().get_first_node_in_group("Player")
		var chsel=get_tree().get_first_node_in_group("char_manager")
		if plr!=null:
			plr.queue_free()
		if chsel!=null:
			chsel.spawn_character(game_manager.current_char_id)
		loading_save=false
	else:
		print("nothing to load")
		current_room_category=0 
		current_room_id=0
		current_combat_group=0
