extends Upgrade

var a = false

func _process(delta):
	if enabled:
		if manager.player != null and !a:
			manager.player.move_speed_multiplier -= .3
			manager.player.dash_speed_multiplier -= .25
			manager.weapon_manager.damage_multiplier += 1.5
			a = true
