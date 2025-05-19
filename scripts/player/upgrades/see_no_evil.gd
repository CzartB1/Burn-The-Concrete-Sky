extends Upgrade

@export var vignette:Control
var a = false

func _ready():
	vignette.visible=false

func _process(delta):
	if enabled:
		if manager.player != null and !a:
			vignette.visible=true
			manager.player.move_speed_multiplier += .2
			manager.player.dash_speed_multiplier += .2
			a = true
