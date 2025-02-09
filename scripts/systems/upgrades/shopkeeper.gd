class_name Shopkeeper
extends Area3D

var interactible = false
@export var shop_screen:Shop_Screen
@export var screen_canvas: CanvasLayer
var econom:Player_Economy_Manager
var plr:Player

func _ready():
	if shop_screen: shop_screen.toggle_menu(false)

func _process(_delta):
	if econom==null:
		econom=get_tree().get_first_node_in_group("Economy")
		
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	
	if Input.is_action_just_pressed("interact") and interactible and !plr.disabled:
		print("interact")
		econom.hide_money()
		econom.hide_mult()
		shop_screen.toggle_menu(true)
		plr.show_cursor = true
		plr.disabled=true

func _on_body_entered(body):
	if body is Player:
		interactible = true
		screen_canvas.layer=6
		#make player character unable to move or interact or anything

func _on_body_exited(body):
	if body is Player:
		interactible = false
		screen_canvas.layer=1

func rand_upgrades():
	shop_screen.rand_upgrades()
	shop_screen.rand_weapons()

func disable_shop():
	if shop_screen: 
		shop_screen.toggle_menu(false)
		if shop_screen.plr!=null:shop_screen.plr.disabled=false
