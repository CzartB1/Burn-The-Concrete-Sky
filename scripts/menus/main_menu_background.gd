class_name MainMenuBackground
extends Node3D

@export var flicker_enabled: bool = false

@export var lights: Array[Light3D] = []
@export var min_intensity: float = 0.1
@export var max_intensity: float = 2.0
@export var flicker_speed: float = 5.0
@export var light_transition_speed: float = 3.0

@export var particles: Array[GPUParticles3D] = []
@export var target_particle_amount: int = 1000
@export var particle_transition_speed: float = 3.0

@export var world_environment: WorldEnvironment
@export var fixed_bg_color: Color = Color(0.1, 0.1, 0.1)
@export var flicker_bg_color1: Color = Color(0.05, 0.05, 0.05)
@export var flicker_bg_color2: Color = Color(1.0, 0.5, 0.0)
@export var bg_flicker_speed: float = 2.0
@export var bg_transition_speed: float = 3.0

func _process(delta: float) -> void:
	if flicker_enabled:
		for light in lights:
			light.visible = true
			var target = randf_range(min_intensity, max_intensity)
			light.light_energy = lerp(light.light_energy, target, flicker_speed * delta)
		for part in particles:
			part.emitting=true
		if world_environment and world_environment.environment:
			var current = world_environment.environment.background_color
			var target_bg = Color(
				randf_range(flicker_bg_color1.r, flicker_bg_color2.r),
				randf_range(flicker_bg_color1.g, flicker_bg_color2.g),
				randf_range(flicker_bg_color1.b, flicker_bg_color2.b),
				randf_range(flicker_bg_color1.a, flicker_bg_color2.a)
			)
			world_environment.environment.background_color = Color(
				lerp(current.r, target_bg.r, bg_flicker_speed * delta),
				lerp(current.g, target_bg.g, bg_flicker_speed * delta),
				lerp(current.b, target_bg.b, bg_flicker_speed * delta),
				lerp(current.a, target_bg.a, bg_flicker_speed * delta)
			)
	else:
		for light in lights:
			light.light_energy = 0
			light.visible = false
		for part in particles:
			part.emitting=false
		if world_environment and world_environment.environment:
			var current = world_environment.environment.background_color
			world_environment.environment.background_color = Color(
				lerp(current.r, fixed_bg_color.r, bg_transition_speed * delta),
				lerp(current.g, fixed_bg_color.g, bg_transition_speed * delta),
				lerp(current.b, fixed_bg_color.b, bg_transition_speed * delta),
				lerp(current.a, fixed_bg_color.a, bg_transition_speed * delta)
			)
