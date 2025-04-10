extends HBoxContainer

@export var weapon_holder:Weapon_Manager
@export_group("Boxes")
@export var box_1:ColorRect
@export var box_2:ColorRect
@export_group("Colors")
@export var active_color:Color
@export var inactive_color:Color
@export_group("Weapon Infos")
@export var ammo_c_1:Label
@export var ammo_c_2:Label
@export var icon_1:TextureRect
@export var icon_2:TextureRect
@export_group("Crosshairs")
@export var crosshair:TextureRect
@export var crosshair_reload:TextureRect
var w1_ammo:int
var w2_ammo:int

func _ready():
	if weapon_holder: select_check()

func _process(delta):
	if !weapon_holder: weapon_holder=get_tree().get_first_node_in_group("weapon_holder")
	if Input.is_action_just_pressed("weapon_1") or Input.is_action_just_pressed("weapon_2"):
		select_check()
	
	if weapon_holder.selected_weapon==1 and weapon_holder.weapons[weapon_holder.current_1_id] is Projectile_Gun:
		if weapon_holder.weapons[weapon_holder.current_1_id].is_reloading:
			crosshair.visible=false
			crosshair_reload.visible=true
		elif !weapon_holder.weapons[weapon_holder.current_1_id].is_reloading:
			crosshair.visible=true
			crosshair_reload.visible=false
	if weapon_holder.selected_weapon==2 and weapon_holder.weapons[weapon_holder.current_2_id] is Projectile_Gun:
		if weapon_holder.weapons[weapon_holder.current_2_id].is_reloading:
			crosshair.visible=false
			crosshair_reload.visible=true
		elif !weapon_holder.weapons[weapon_holder.current_2_id].is_reloading:
			crosshair.visible=true
			crosshair_reload.visible=false
	ammo_check()

func ammo_check():
	if weapon_holder.weapons[weapon_holder.current_1_id].icon!=null: icon_1.texture=weapon_holder.weapons[weapon_holder.current_1_id].icon
	if weapon_holder.weapons[weapon_holder.current_2_id].icon!=null: icon_2.texture=weapon_holder.weapons[weapon_holder.current_2_id].icon
	if weapon_holder.weapons[weapon_holder.current_1_id] is Projectile_Gun: 
		ammo_c_1.visible=true
		w1_ammo=weapon_holder.weapons[weapon_holder.current_1_id].current_ammo
		ammo_c_1.text=str(w1_ammo)+"/"+str(weapon_holder.weapons[weapon_holder.current_1_id].max_ammo)
	elif weapon_holder.weapons[weapon_holder.current_1_id] is melee_weapon: ammo_c_1.visible=false
	if weapon_holder.weapons[weapon_holder.current_2_id] is Projectile_Gun: 
		ammo_c_2.visible=true
		w2_ammo=weapon_holder.weapons[weapon_holder.current_2_id].current_ammo
		ammo_c_2.text=str(w2_ammo)+"/"+str(weapon_holder.weapons[weapon_holder.current_2_id].max_ammo)
	elif weapon_holder.weapons[weapon_holder.current_2_id] is melee_weapon: ammo_c_2.visible=false

func select_check():
	if weapon_holder.selected_weapon==1:
		box_1.color=active_color
		box_2.color=inactive_color
	if weapon_holder.selected_weapon==2:
		box_2.color=active_color
		box_1.color=inactive_color
