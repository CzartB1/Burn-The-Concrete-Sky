class_name Shopkeeper
extends Area3D

var interactible = false
@export var upgrade_screen: Upgrade_Menu
@export var weapon_screen: Weapon_Screen
@export var screen_canvas: CanvasLayer
var econom:Player_Economy_Manager
var plr:Player

func _ready():
	if upgrade_screen!=null: upgrade_screen.toggle_menu(false)
	if weapon_screen!=null:weapon_screen.toggle_menu(false)

func _process(_delta):
	if econom==null:
		econom=get_tree().get_first_node_in_group("Economy")
		
	if  plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	
	if Input.is_action_just_pressed("interact") and interactible and !plr.disabled:
		print("interact")
		econom.hide_money()
		econom.hide_mult()
		if upgrade_screen!=null: upgrade_screen.toggle_menu(true)
		if weapon_screen!=null:weapon_screen.toggle_menu(true)
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
	if upgrade_screen!=null: upgrade_screen.rand_upgrades()
	if weapon_screen!=null:weapon_screen.rand_weapons()

func disable_shop():
	if weapon_screen!=null:
		weapon_screen.toggle_menu(false)
		if weapon_screen.plr!=null:weapon_screen.plr.disabled=false
	if upgrade_screen!=null:
		upgrade_screen.toggle_menu(false)
		if upgrade_screen.plr!=null:upgrade_screen.plr.disabled=false
