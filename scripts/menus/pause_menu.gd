extends CanvasLayer

@export var menu:Control
@export var HUD:Control
var plr

func _process(delta):
	plr = get_tree().get_first_node_in_group("Player")
	HUD.visible=!game_manager.paused
	menu.visible=game_manager.paused
	if Input.is_action_just_pressed("pause"):
		if game_manager.paused:
			plr.show_cursor = false
			game_manager.unpause()
			layer=1
		elif !game_manager.paused:
			plr.show_cursor = true
			game_manager.pause()
			layer=5
			var shp=get_tree().get_nodes_in_group("shops")
			for i in shp:
				if i is Shopkeeper: i.disable_shop()

func _on_resume_pressed():
	if game_manager.paused:
		plr.show_cursor = true
		game_manager.unpause()

func _on_exit_desktop_pressed():
	get_tree().quit()

func _on_main_menuu_exit_pressed():
	game_manager.kill_all_enemies()
	plr.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game_manager.show_char_select=true
	game_manager.unpause()
	Engine.time_scale=1
	get_tree().change_scene_to_file("res://scene/menus/main_menu.tscn")
	print("quitting to menu")

func _on_restart_pressed():
	game_manager.kill_all_enemies()
	game_manager.restart(true)
	game_manager.unpause()
	Engine.time_scale=1
