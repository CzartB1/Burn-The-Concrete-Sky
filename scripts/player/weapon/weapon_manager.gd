class_name Weapon_Manager
extends Node3D

@export var master:Player
@export_group("weapon")
@export var selected_weapon:int = 1
@export var current_1_id:int = 0
@export var current_2_id:int = 0
@export var weapons:Array[Node3D]
var available_weapons:Array[Node3D]
var erase_fist=false
@export_group("modifiers")
@export var attack_speed_modifier = 0
@export var attack_speed_multiplier = 1
@export var damage_modifier = 0
@export var damage_multiplier = 1
@export var spread_modifier = 0
@export var spread_multiplier = 1
@export_group("UI")
@export var ammo_counter:Label #FIXME tweak the others cuz how this get the node kinda changed. If forgot, copy composition of Silver's weapon holder

func _ready():
	weapon_availability_check()

func _process(_delta):
	clampi(selected_weapon,1,2)
	
	for i in get_child_count():
		if get_child(i) is Projectile_Gun and get_child(i).manager != self:
			get_child(i).manager = self
		elif get_child(i) is melee_weapon and get_child(i).manager != self:
			get_child(i).manager = self
	
	if spread_modifier < 0:
		spread_modifier = -spread_modifier
	if spread_multiplier < 0:
		spread_multiplier = -spread_multiplier
	
	if Input.is_action_just_pressed("weapon_1"):
		selected_weapon=1
	elif Input.is_action_just_pressed("weapon_2"):
		selected_weapon=2
	
	if Input.is_action_just_pressed("switch_weapon"):
		switch_weapon()
	
	gun_check()
	#weapon_availability_check() 

func gun_check():
	if selected_weapon==1:
		for i in weapons.size():
			if i != current_1_id:
				weapons[i].process_mode=Node.PROCESS_MODE_DISABLED
				weapons[i].visible = false
			elif i == current_1_id:
				weapons[i].process_mode=Node.PROCESS_MODE_INHERIT
				weapons[i].visible = true
	if selected_weapon==2:
		for i in weapons.size():
			if i != current_2_id:
				weapons[i].process_mode=Node.PROCESS_MODE_DISABLED
				weapons[i].visible = false
			elif i == current_2_id:
				weapons[i].process_mode=Node.PROCESS_MODE_INHERIT
				weapons[i].visible = true

func weapon_availability_check():
	available_weapons.clear()
	available_weapons.append_array(weapons)
	available_weapons.erase(weapons[current_1_id])
	available_weapons.erase(weapons[current_2_id])
	available_weapons.erase(weapons[0])
	print(str(available_weapons))

func switch_weapon():
	var a = current_1_id
	var b = current_2_id
	current_1_id=b
	current_2_id=a

func change_weapon_1(new_gun_id:int): 
	# apparently, theres a difference between between the IDs in weapons and available weapons
	# the difference is only by like 2, but it can really fuck up the weapon selection system
	# Man, I was questioning my sanity when fixing this shit 
	current_1_id=weapons.find(available_weapons[new_gun_id])
	gun_check()
	weapon_availability_check()


func change_weapon_2(new_gun_id:int):
	current_2_id=weapons.find(available_weapons[new_gun_id])
	gun_check()
	weapon_availability_check()
