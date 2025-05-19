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
			var wh=get_tree().get_first_node_in_group("weapon_holder")
			if wh is Weapon_Manager: wh.damage_multiplier+=1
			a = true
