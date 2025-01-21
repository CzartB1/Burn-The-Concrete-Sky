extends Area3D

var interactible = false
@export var weapon_screen: Starting_Weapon_Screen
@export var canvas:CanvasLayer
@export var from_start=false
var plr:Player

func _ready():
	weapon_screen.toggle_menu(false)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	canvas.layer=1

func _process(_delta):
	if weapon_screen.has_selected:queue_free()
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	elif plr!=null:
		if from_start: 
			plr.show_cursor = true
			plr.disabled=true
			Dialogic.start("justicar_intro")
			from_start=false
#
#func _on_body_entered(body):
	#if body is Player:
		#interactible = true

func _on_body_exited(body):
	if body is Player:
		interactible = false
		canvas.layer=1

func rand_upgrades():
	weapon_screen.rand_weapons()

func activate():
	weapon_screen.toggle_menu(true)
	rand_upgrades()
	canvas.layer=6

func walkaway():
	if  plr == null:plr = get_tree().get_first_node_in_group("Player")
	plr.show_cursor = false
	plr.disabled=false
	queue_free()

func _on_dialogic_signal(argument:String):
	if argument=="justicar_start":
		activate()
	if argument=="walkaway_start":
		walkaway()
