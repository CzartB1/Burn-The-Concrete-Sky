extends Upgrade

var a = false

func _ready():
	pass

func _process(delta):
	if enabled:
		if manager.player != null and !a:
			manager.player.move_speed_multiplier += .5
			manager.player.dash_speed_multiplier += .25
			a = true
