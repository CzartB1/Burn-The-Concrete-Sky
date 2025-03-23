extends Area3D

@export var active_duration: float = 1.5  # Duration the steam bursts forth.
@export var idle_duration: float = 2.5    # Lull between the bursts.
@export var damage_amount: int = 10         # The scorching damage delivered per tick.
@export var damage_interval: float = 0.5    # Interval between damage pulses.

@export var steam_particles: GPUParticles3D
@export var damage_timer: Timer

func _ready() -> void:
	# Prepare the timer to periodically invoke the searing wrath.
	damage_timer.wait_time = damage_interval
	steam_cycle()

func steam_cycle() -> void:
	while true:
		# Engage the inferno: steam ignites and the area becomes lethal.
		steam_particles.emitting = true
		damage_timer.start()
		await get_tree().create_timer(active_duration).timeout
		
		# The vent withdraws its fury, leaving only silence in its wake.
		steam_particles.emitting = false
		damage_timer.stop()
		await get_tree().create_timer(idle_duration).timeout

func _on_damage_timer_timeout():
	# Ensure damage only flows when the steam roars to life.
	if not steam_particles.emitting:
		return
	# For each entity ensnared within this burning domain, inflict the searing pain.
	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(damage_amount)
