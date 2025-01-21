extends Enemy_Behavior_Master

@onready var heal_timer=$heal_timer
var enemy_to_heal:Array[Enemy]=[]

func _on_heal_timer_timeout():
	if enemy_to_heal.size()>0:
		for i in enemy_to_heal:
			if i.hp<i.hp_start and i!=master:
				print(str(i.name)+" not healed "+str(i.hp))
				i.take_damage(-1)
				print(str(i.name)+" healed "+str(i.hp))
		heal_timer.start()


func _on_area_3d_body_entered(body):
	if body is Enemy and body != master:
		enemy_to_heal.append(body)


func _on_area_3d_body_exited(body):
	if body is Enemy and enemy_to_heal.has(body):
		enemy_to_heal.erase(body)
