extends Control

@export var kill_label:RichTextLabel
@export var rooms_cleared_label:RichTextLabel
@export var playtime_label:RichTextLabel
@export var money_label:RichTextLabel
@export var mult_label:RichTextLabel
@export var anim:AnimationPlayer

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

func _on_restart_pressed():
	game_manager.restart(false)

func _on_choose_char_pressed():
	game_manager.restart(true)

func _on_exit_pressed(): #FIXME main menu button
	get_tree().change_scene_to_file("res://scene/menus/main_menu.tscn")

func show_anim():
	anim.play("show")
