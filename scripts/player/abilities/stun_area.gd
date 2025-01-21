extends Area3D

@export var affect_player:bool=false
@export var affect_enemies:bool=true
@export var duration:float
@export var radius:float
var active=true
var enemies:Array[Enemy]

func _on_body_entered(bod):
	if bod is Enemy and active:
		bod.stunned=true
		enemies.append(bod)
		print("found enemy")
		active=false

func _on_timer_timeout():
	if enemies!=null:
		for en in enemies:
			if en!=null and en.stunned:
				en.stunned=false
	enemies.clear()
	queue_free()
