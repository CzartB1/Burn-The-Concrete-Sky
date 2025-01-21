extends Upgrade

var a = false

func _process(delta):
	var a2
	if enabled:
		if manager.player != null and manager.player.time_slowed and !a:
			manager.weapon_manager.spread_multiplier = 0.2
			a = true
		elif manager.player != null and !manager.player.time_slowed and a:
			manager.weapon_manager.spread_multiplier = 2
			a = false
