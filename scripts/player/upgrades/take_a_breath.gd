extends Upgrade

var a = false
var orig

func _process(delta):
	var a2
	if enabled:
		if manager.player != null and manager.player.velocity==Vector3.ZERO and !a: # not move
			orig = manager.player.time_slow_recharge_multiplier_add
			manager.player.time_slow_recharge_multiplier_add += 5
			a = true
		elif manager.player != null and manager.player.velocity!=Vector3.ZERO and a: # move
			if orig != null: manager.player.time_slow_recharge_multiplier_add = orig
			a = false
		
