extends Upgrade

var frame_between_calls:=20
var frame_counter:=0
var recorded_enemy=[]

func _process(delta: float) -> void:
	if enabled:
		if frame_counter <= frame_between_calls:
			var ens = get_tree().get_nodes_in_group("Enemy")
			if ens.size()<=0: recorded_enemy.clear()
			for enemy in ens:
				if enemy is Enemy and enemy.has_tag("mage") and !recorded_enemy.has(enemy):
					recorded_enemy.append(enemy)
					enemy.damage_taken_mult+=1
					print(enemy.name+" is a mage!")
		elif frame_counter > frame_between_calls: frame_counter+=1
