extends Node
class_name UI_Sound_Manager

# assign these in the Inspector:
@export var hover_sound: AudioStream
@export var press_sound: AudioStream

var buttons: Array[Button] = []
var _hover_player: AudioStreamPlayer
var _press_player: AudioStreamPlayer

func _ready() -> void:
	# create two AudioStreamPlayers for hover & press
	_hover_player = AudioStreamPlayer.new()
	add_child(_hover_player)
	_hover_player.bus="SFX"
	_press_player = AudioStreamPlayer.new()
	add_child(_press_player)
	_press_player.bus="SFX"
	_hover_player.process_mode=Node.PROCESS_MODE_ALWAYS
	_press_player.process_mode=Node.PROCESS_MODE_ALWAYS

	# find all buttons under this node
	_find_buttons(get_tree().get_current_scene())
	# connect their signals
	for btn in buttons:
		btn.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		btn.connect("pressed",        Callable(self, "_on_button_pressed"))

func _find_buttons(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			buttons.append(child)
		# recurse
		_find_buttons(child)

func _on_button_pressed() -> void:
	if press_sound:
		_press_player.stream = press_sound
		_press_player.play()

func _on_mouse_entered():
	if hover_sound:
		_hover_player.stream = hover_sound
		_hover_player.play()
