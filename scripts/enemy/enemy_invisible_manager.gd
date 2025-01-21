extends Node3D

@export var enemy_behavior:Enemy_Behavior_Master
@export var things_to_hide:Array[MeshInstance3D]=[]
@export_range(0,1)var invisibility_amount:float=0.85

func _process(_delta):
	if enemy_behavior.is_attacking:
		for i in things_to_hide:
			i.transparency=0
			i.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	elif !enemy_behavior.is_attacking:
		for i in things_to_hide:
			i.transparency=invisibility_amount
			i.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
