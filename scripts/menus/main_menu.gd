extends CanvasLayer

@export var game_scene:PackedScene
@export var anim:AnimationPlayer
@export var settingsMenu:Control
@export var creditsMenu:Control
@export var background_scene:MainMenuBackground
@export var intro:PoemIntro
@export var focus_button:Button
@export var main_light:DirectionalLight3D
@export_group("music")
@export var aud_plr:AudioStreamPlayer
@export var amb_plr:AudioStreamPlayer
@export var soft_theme:AudioStream
@export var rough_theme:AudioStream
@export var soft_ambient:AudioStream
@export var rough_ambient:AudioStream
var pressed=false
var foc=false

func _ready():
	settingsMenu.visible=false
	creditsMenu.visible=false
	settingsMenu.z_index=0
	creditsMenu.z_index=0
	main_light.light_energy=1
	aud_plr.stream=soft_theme
	aud_plr.play()
	amb_plr.stream=soft_ambient
	amb_plr.play()
	

func _process(_delta):
	if !intro.intro_finished:return
	if !pressed and Input.is_anything_pressed():
		aud_plr.stream=rough_theme
		aud_plr.play()
		amb_plr.stream=rough_ambient
		amb_plr.play()
		background_scene.flicker_enabled=true
		anim.play("title_screen_press")
		pressed=true
		main_light.light_energy=0
	elif pressed:
		if focus_button!=null and !foc:
			if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				focus_button.grab_focus() #TODO make it so that the game remembers which icon was last focused, and make the play button's top focus the last focused icon
				foc=true

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scene/test_world.tscn")

func _on_exit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	settingsMenu.visible=true
	settingsMenu.z_index=7

func _on_credit_pressed():
	creditsMenu.visible=true
	creditsMenu.z_index=7
	creditsMenu.restart_pos()
	creditsMenu.start_scrolling=true
