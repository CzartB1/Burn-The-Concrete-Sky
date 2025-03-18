extends Control

@export var kill_label:RichTextLabel
@export var rooms_cleared_label:RichTextLabel
@export var playtime_label:RichTextLabel
@export var money_label:RichTextLabel
@export var mult_label:RichTextLabel
@export var anim:AnimationPlayer
var plr

func _ready():
	visible=true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#TODO disable the player, pause game, and show mouse

func _process(delta):
	kill_label.text="Kills: "+str(game_manager.stat_kills)
	rooms_cleared_label.text="Rooms Cleared: "+str(game_manager.stat_roomcleared)
	playtime_label.text="Playtime: "+str(game_manager.stop_count_time())
	money_label.text="Money Earned: "+str(game_manager.stat_moneyearned)
	mult_label.text="Highest Multiplier: "+str(game_manager.stat_highestmult)
	
	plr = get_tree().get_first_node_in_group("Player")

func _on_restart_pressed():
	game_manager.restart(false)

func _on_choose_char_pressed():
	game_manager.restart(true)

func _on_exit_pressed(): #FIX ME main menu button
	game_manager.kill_all_enemies()
	plr.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	game_manager.show_char_select=true
	game_manager.unpause()
	Engine.time_scale=1
	get_tree().change_scene_to_file("res://scene/menus/main_menu.tscn")
	print("quitting to menu")

func show_anim():
	anim.play("show")
	game_manager.pause()
