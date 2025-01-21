extends Control

@export var game_scene:PackedScene

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scene/test_world.tscn")

func _on_exit_pressed():
	get_tree().quit()
