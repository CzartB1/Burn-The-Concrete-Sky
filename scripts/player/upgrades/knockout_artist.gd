extends Upgrade

@export var damage_mult:int=5
var a = false

func _ready():
	pass

func _process(delta):
	if enabled:
		if manager.player != null and !a:
			var wh=get_tree().get_first_node_in_group("weapon_holder")
			if wh is Weapon_Manager:
				for weapon in wh.weapons:
					if weapon.has_tag("unarmed"): weapon.damage_mult+=damage_mult
			a = true
