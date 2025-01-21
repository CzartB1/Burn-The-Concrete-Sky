extends HBoxContainer

@export var weapon_holder:Weapon_Manager
@export_group("Boxes")
@export var box_1:ColorRect
@export var box_2:ColorRect
@export_group("Colors")
@export var active_color:Color
@export var inactive_color:Color
@export_group("Ammo Counters")
@export var ammo_c_1:Label
@export var ammo_c_2:Label
var w1_ammo:int
var w2_ammo:int

func _ready():
	select_check()

func _process(delta):
	if Input.is_action_just_pressed("weapon_1") or Input.is_action_just_pressed("weapon_2"):
		select_check()
	ammo_check()

func ammo_check():
	if weapon_holder.weapons[weapon_holder.current_1_id] is Projectile_Gun: 
		ammo_c_1.visible=true
		w1_ammo=weapon_holder.weapons[weapon_holder.current_1_id].current_ammo
		ammo_c_1.text=str(w1_ammo)+"/"+str(weapon_holder.weapons[weapon_holder.current_1_id].max_ammo)
	elif weapon_holder.weapons[weapon_holder.current_1_id] is melee_weapon: ammo_c_1.visible=false
	if weapon_holder.weapons[weapon_holder.current_2_id] is Projectile_Gun: 
		ammo_c_1.visible=true
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
