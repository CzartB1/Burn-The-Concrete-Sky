extends Enemy_Behavior_Master

@export var charge_damage:int = 3
@export var charge_speed = 20.0  # Speed when charging
@export var detection_range = 15.0  # Detection range
@export var charge_duration = 2.0  # Max time spent charging
@export var charge_ray:RayCast3D  # RayCast node for detection
@export var dist_to_attack = 8.0
@export var charge_delay=Vector2(0.0,1.2)
@export var cooldown_timer:Timer

var target_position:Vector3=Vector3.ZERO  # Player's position
var charge_timer_frames = 0  # Timer in frames
var can_attack=true
var charging=false

func _process(delta):
	super._process(delta)
	if charge_timer_frames > 0:
		if target_position==Vector3.ZERO or target_position==null: target_position = target
		perform_charge()
	elif charge_timer_frames <= 0:
		end_charging()

func attack():
	if !can_attack or master.global_position.distance_to(target)>dist_to_attack and !detect_player():return
	start_charging()

func detect_player():
	if charge_ray.is_colliding():
		var collider = charge_ray.get_collider()
		if collider and collider.is_in_group("player"):
			target_position = target
			return true
	return false

# Initialize charging (to be called once when charging begins)
func start_charging(): #FIXME THANKS GPT, BUT NOT REALLY!!!!
	await get_tree().create_timer(randf_range(charge_delay.x,charge_delay.y)).timeout
	master.stop_nav=true
	can_attack=false
	charging=true
	charge_timer_frames = int(charge_duration * Engine.get_frames_per_second())

# Perform charging (call this every frame during charging)
func perform_charge():
	if !charging:return
	master.stop_nav=true
	disable_look=true
	master._on_velocity_computed(global_transform.basis.z*-charge_speed)
	charge_timer_frames -= 1
	return charge_timer_frames <= 0

func end_charging():
	master.stop_nav=false
	disable_look=false
	charging=false
	cooldown_timer.start()

func _on_charge_hitbox_body_entered(body):
	if !charging: return
	end_charging()
	if body is Player: body.take_damage(charge_damage)
	elif body is Enemy and body!=master: body.take_damage(charge_damage)

func _on_cooldown_timer_timeout():
	can_attack=true
