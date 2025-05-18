class_name BaseWeapon
extends Node3D

@export var manager: Weapon_Manager
@export var tags: Array[String] = []
var audio_direct=preload("res://scene/utilities/audio_direct.tscn")
var holding=false
var can_attack=true
@export_group("shop")
@export var price:int=100
@export_group("lore")
@export var icon:AtlasTexture
@export_multiline var Description:String

func _process(_delta):
	if manager.master.alive and !manager.master.disabled and !game_manager.paused and !manager.master.in_dialogue:
		if can_attack and Input.is_action_just_pressed("attack"):
			attack_press()
		if can_attack and Input.is_action_pressed("attack"):
			holding=true
			attack_hold()
		if can_attack and Input.is_action_just_released("attack"):
			attack_released()
			holding=false

func attack_press():
	pass

func attack_hold():
	pass

func attack_released():
	pass

func play_sound(austr:AudioStream):
	if austr!=null:
		var audio=audio_direct.instantiate()
		add_child(audio)
		audio.play_sound(austr)
	elif !austr:
		print("sound not found")

func has_tag(tag: String) -> bool:
	return tag in tags

func get_tags() -> String:
	var result := ""
	for tag in tags:
		result += "[ " + tag.capitalize() + " ] "
	return result.strip_edges()
