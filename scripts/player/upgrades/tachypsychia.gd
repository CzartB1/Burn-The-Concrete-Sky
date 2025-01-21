extends Upgrade

var a = false

func _process(delta):
	if enabled:
		if manager.player != null and manager.player.time_slowed and !a:
			manager.player.move_speed_multiplier += 1.5
			a = true
		elif manager.player != null and !manager.player.time_slowed and a:
			manager.player.move_speed_multiplier -= 1.5
			a = false
