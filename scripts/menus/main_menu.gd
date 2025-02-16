extends CanvasLayer

@export var game_scene:PackedScene
@export var anim:AnimationPlayer
@export var settingsMenu:Control
@export var background_scene:MainMenuBackground
@export var intro:PoemIntro
var pressed=false

func _ready():
	settingsMenu.visible=false
	settingsMenu.z_index=0

func _process(_delta):
	if !pressed and Input.is_anything_pressed() and intro.intro_finished:
		background_scene.flicker_enabled=true
		anim.play("title_screen_press")
		pressed=true

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scene/test_world.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	settingsMenu.visible=true
	settingsMenu.z_index=7
