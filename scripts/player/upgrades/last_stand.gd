extends Upgrade

var a = false
@export var i_timer:Timer

func _process(delta):
	if enabled:
		if manager.player != null and !a and !manager.player.alive:
			manager.player.hp=int(manager.player.HP_bar.max_value*.25)
			manager.player.alive=true
			Engine.time_scale = 1
			manager.player.invulnerable=true
			i_timer.start()
			a=true

func _on_timer_timeout():
	manager.player.invulnerable=false
