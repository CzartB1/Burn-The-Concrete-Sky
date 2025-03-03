class_name Upgrade_Button
extends Button

var plr:Player
var up_object:Upgrade
var price:int=100
@export var upgrade_id:int
@export var menu:Shop_Screen
@export var button_enable:Control
@export var button_disable:Control
@export var description_box:RichTextLabel


func _process(_delta):
	if plr == null:
		plr = get_tree().get_first_node_in_group("Player")
	
	if up_object!=null:
		price=up_object.price
		text=up_object.name+" - "+str(price)

func _on_pressed():
	var econom=get_tree().get_first_node_in_group("Economy")
	button_disable.visible=false
	button_enable.visible=true
	menu.item_icon.texture=up_object.icon
	if up_object!=null:
		description_box.text=up_object.Description
	if plr!=null and econom is Player_Economy_Manager:
		if econom.money-price>=0: #if can buy
			menu.selected_weapon_id=upgrade_id
			menu.has_selected=true
			menu.selected=up_object
			menu.selected_button=self
			plr.upgrade_manager.upgrade_availability_check()
			#disabled=true
		elif econom.money-price<0:
			print("ur broke")
			#TODO play insufficient fund sound effect
