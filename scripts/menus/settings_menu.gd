extends CanvasLayer

@export var master_slider:HSlider
@export var music_slider:HSlider
@export var sfx_slider:HSlider
@export var resolution_option:OptionButton
@export var fullscreen_toggle:CheckBox
@export var schoolmode_toggle:CheckBox
@export var menu:Control

const CONFIG_PATH = "user://settings.cfg"
var config = ConfigFile.new()
var resolutions = [
	Vector2i(1920, 1080),
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900)
]

func _ready():
	# Setup resolution options
	for res in resolutions:
		resolution_option.add_item("%dx%d" % [res.x, res.y])
	
	# Load existing settings or defaults
	load_settings()

func load_settings():
	# Load config file or set defaults
	var err = config.load(CONFIG_PATH)
	if err != OK:
		set_defaults()
		return
	
	# Audio Settings
	set_bus_volume("Master", config.get_value("audio", "master", 1.0))
	set_bus_volume("Music", config.get_value("audio", "music", 1.0))
	set_bus_volume("SFX", config.get_value("audio", "sfx", 1.0))
	
	# Video Settings
	var current_res = config.get_value("video", "resolution", Vector2i(1280, 720))
	var fullscreen = config.get_value("video", "fullscreen", false)
	
	game_manager.school_mode=config.get_value("gameplay", "schoolmode", false)
	
	# Update UI
	master_slider.value = config.get_value("audio", "master", 1.0) * 100
	music_slider.value = config.get_value("audio", "music", 1.0) * 100
	sfx_slider.value = config.get_value("audio", "sfx", 1.0) * 100
	resolution_option.selected = resolutions.find(current_res)
	fullscreen_toggle.button_pressed = fullscreen
	schoolmode_toggle.button_pressed = game_manager.school_mode
	
	# Apply video settings
	apply_video_settings(current_res, fullscreen)

func set_defaults():
	set_bus_volume("Master", 1.0)
	set_bus_volume("Music", 1.0)
	set_bus_volume("SFX", 1.0)
	apply_video_settings(Vector2i(1280, 720), false)

func set_bus_volume(bus_name: String, linear_volume: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var db_volume
	if linear_volume <= 0:
		db_volume = -80  # Muted
	else:
		db_volume = linear_to_db(linear_volume)
	AudioServer.set_bus_volume_db(bus_index, db_volume)

func apply_video_settings(resolution: Vector2i, fullscreen: bool):
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolution)

func save_settings():
	# Audio Settings
	config.set_value("audio", "master", master_slider.value / 100)
	config.set_value("audio", "music", music_slider.value / 100)
	config.set_value("audio", "sfx", sfx_slider.value / 100)
	
	# Video Settings
	config.set_value("video", "resolution", resolutions[resolution_option.selected])
	config.set_value("video", "fullscreen", fullscreen_toggle.button_pressed)
	
	# Gameplay
	config.set_value("gameplay", "schoolmode", schoolmode_toggle.button_pressed)
	
	config.save(CONFIG_PATH)

func _on_back_button_pressed():
	save_settings()
	menu.visible=false
	menu.z_index=0

func _on_fullscreen_toggle_toggled(button_pressed):
	apply_video_settings(resolutions[resolution_option.selected], button_pressed)

func _on_resolution_option_item_selected(index):
	apply_video_settings(resolutions[index], fullscreen_toggle.button_pressed)

func _on_master_slider_value_changed(value):
	set_bus_volume("Master", value / 100)

func _on_music_slider_value_changed(value):
	set_bus_volume("Music", value / 100)

func _on_sfx_slider_value_changed(value):
	set_bus_volume("SFX", value / 100)

func _on_schoolmode_toggled(toggled_on):
	game_manager.school_mode=toggled_on
