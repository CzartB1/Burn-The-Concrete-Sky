class_name Shopkeeper
extends Area3D

var interactible = false
@export var shop_screen:Shop_Screen
@export var screen_canvas: CanvasLayer
@export var dialogic_dialogue:String
@export var input_text:Label3D
var econom:Player_Economy_Manager
var plr:Player
var show_s=false

func _ready():
	if shop_screen: shop_screen.toggle_menu(false)
	Dialogic.signal_event.connect(_on_dialogic_signal)
	#rand_upgrades()

func _process(_delta):
	if !shop_screen:
		var ch=get_children(true)
		for c in ch: 
			if c is Shop_Screen: shop_screen=c
	if econom==null:
		econom=get_tree().get_first_node_in_group("Economy")
	if  plr == null:plr = get_tree().get_first_node_in_group("Player")
	if Input.is_action_just_pressed("interact") and interactible and !plr.disabled and !plr.in_dialogue:
		print("interact")
		econom.hide_money()
		econom.hide_mult()
		plr.in_dialogue=true
		plr.can_move=false
		if dialogic_dialogue:
			Dialogic.start(dialogic_dialogue)
		elif !dialogic_dialogue:
			show_menu()
	if show_s: #IDK why show_menu() don't wanna be called by Dialogic. This is my solution.
		show_menu()
		show_s=false

func show_menu():
	if  plr == null:plr = get_tree().get_first_node_in_group("Player")
	if shop_screen==null: shop_screen=get_tree().get_first_node_in_group("shop_screen")
	shop_screen.toggle_menu(true)
	plr.show_cursor = true
	plr.disabled=true

func _on_body_entered(body):
	if body is Player:
		interactible = true
		screen_canvas.layer=6
		#make player character unable to move or interact or anything
		input_text.visible=true

func _on_body_exited(body):
	if body is Player:
		interactible = false
		screen_canvas.layer=1
		input_text.visible=false

func rand_upgrades():
	shop_screen.rand_upgrades()
	shop_screen.rand_weapons()

func disable_shop():
	if shop_screen: 
		shop_screen.toggle_menu(false)
		if shop_screen.plr!=null:
			shop_screen.plr.disabled=false
			plr.in_dialogue=false
			plr.can_move=true 

func player_exit(): #FIXME when the player refuses to buy, make a signal that calls this func
	if  plr == null:plr = get_tree().get_first_node_in_group("Player")
	plr.in_dialogue=false 
	plr.can_move=true 

func _on_dialogic_signal(argument:String):
	if argument=="open_shop":
		show_s=true
	if argument=="close_shop":
		player_exit()
