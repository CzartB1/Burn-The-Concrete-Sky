class_name enemy_shield
extends Node3D

@export var shield:CollisionShape3D
@export var master:Node3D
@export var dist_to_disable:int=5
@export var hp=5
var plr:Player

func _ready():
	shield.visible=true
	shield.process_mode=Node.PROCESS_MODE_INHERIT

func _process(delta):
	if plr==null:
		plr = get_tree().get_first_node_in_group("Player")
	
	if master.global_position.distance_to(plr.global_position)<dist_to_disable:
		disable_shield()
	elif master.global_position.distance_to(plr.global_position)>=dist_to_disable:
		enable_shield()
	 #TODO create a type of weapon that can go through shields

func enable_shield():
	shield.visible=true
	shield.disabled=false

func disable_shield():
	shield.visible=false
	shield.disabled=true

func take_damage(damage:int):
	print("shield hit")
	hp-=damage


func _on_shieldbodys_body_entered(body):
	if body is Player_Bullet:
		take_damage(body.damage)
