class_name Player_Upgrade_Manager
extends Node3D

@export var player: Player
@export var weapon_manager: Weapon_Manager
@export var upgrade_list: Array[Upgrade]
var available_upgrade: Array[Upgrade]
var equipped_upgrade:Array[Upgrade]

func _ready():
	for u in get_children(): if u == Upgrade: u.Enabled=false
	upgrade_availability_check()

func _process(delta):
	for u in get_children():
		if u == Upgrade and !upgrade_list.has(u):
			upgrade_list.append(u)
	
	for i in upgrade_list:
		if i.manager!=self:
			i.manager=self
	
	for up in equipped_upgrade:
		if available_upgrade.has(up):
			available_upgrade.erase(up)

func upgrade_availability_check():
	available_upgrade.clear()
	available_upgrade.append_array(upgrade_list)
	for up in available_upgrade:
		if up == Upgrade and up.Enabled:
			available_upgrade.erase(up)
	print("avail upgrades: "+str(available_upgrade))
