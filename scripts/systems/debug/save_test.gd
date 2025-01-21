extends Control

func _on_save_pressed():
	SaveManager.save()

func _on_load_pressed():
	SaveManager.load_save()
	game_manager.kill_all_enemies()
	var rm=get_tree().get_first_node_in_group("room_manager")
	if rm is Room_manager: 
		rm.room_count=SaveManager.current_room_count
		rm.select_room(SaveManager.current_room_id,SaveManager.current_room_category, SaveManager.current_combat_group)
