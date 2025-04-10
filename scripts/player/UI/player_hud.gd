extends CanvasLayer

var plr:Player
@export var HUD_object:Control

func _ready():
	if plr==null:plr=get_tree().get_first_node_in_group("Player")
	HUD_object.visible=!plr.in_dialogue

func _process(_delta):
	if plr==null:plr=get_tree().get_first_node_in_group("Player")
	HUD_object.visible=!plr.in_dialogue
