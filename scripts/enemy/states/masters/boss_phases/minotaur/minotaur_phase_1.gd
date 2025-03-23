extends Boss_Phase

@export var master:Enemy
@export_group("Charging")
@export var charge_damage:int = 3
@export var charge_speed = 20.0  # Speed when charging
@export var detection_range = 15.0  # Detection range
@export var charge_duration = 2.0  # Max time spent charging
@export var charge_ray:RayCast3D  # RayCast node for detection
@export var dist_to_attack = 8.0
@export var charge_delay=Vector2(0.0,1.2)
@export var cooldown_timer:Timer
@export var anim_plr:AnimationPlayer
var target_position:Vector3=Vector3.ZERO  # Player's position
var charge_timer_frames = 0  # Timer in frames
var can_attack=true
var charging=false


func _process(delta):
	super._process(delta)
	#charging stuffs
	if charge_timer_frames > 0 and charging:
		behavior.anim.active=false
		behavior.looking=false
		master.axis_lock_angular_y=true
		if target_position==Vector3.ZERO or target_position==null: target_position = behavior.target
		perform_charge()
	elif charge_timer_frames <= 0 and charging:
		if charging:
			end_charging()
		elif !charging:
			behavior.looking=true
			behavior.disable_look=false
			behavior.anim.active=true

func perform_attack():
	if can_attack and detect_player()==true and global_position.distance_to(target_position)<=dist_to_attack and !charging:
		start_charging()

func detect_player():
	if charge_ray.is_colliding():
		var collider = charge_ray.get_collider()
		if collider.is_in_group("Player"):
			target_position = behavior.target
			return true
	return false

# Initialize charging (to be called once when charging begins)
func start_charging():
	if !detect_player():return
	if behavior.anim: behavior.anim.active=false
	if anim_plr: anim_plr.play("attack")
	behavior.looking=false
	master.stop_nav=true
	can_attack=false
	charging=true
	charge_timer_frames = int(charge_duration * Engine.get_frames_per_second())

# Perform charging (call this every frame during charging)
func perform_charge():
	if !charging:return
	#if anim_plr: anim_plr.play("attack")
	master.stop_nav=true
	behavior.disable_look=true
	master._on_velocity_computed(global_transform.basis.z*-charge_speed)
	charge_timer_frames -= 1
	if behavior.anim: behavior.anim.active=false
	return charge_timer_frames <= 0

func end_charging():
	master.stop_nav=false
	#behavior.anim.active=false
	if anim_plr: anim_plr.play("attack_end")
	behavior.stop=true
	charging=false
	cooldown_timer.start()
	#behavior.anim.active=true
	#await get_tree().create_timer(5).timeout
	#can_attack=true

func _on_charge_hitbox_body_entered(body):
	print(body.name)
	if !charging: return
	end_charging()
	if body is Player: body.take_damage(charge_damage)
	elif body is Enemy and body!=master: body.take_damage(charge_damage)
	#behavior.anim.active=true

func _on_cooldown_timer_timeout():
	can_attack=true
	behavior.looking=true
	behavior.disable_look=false
	behavior.anim.active=true

func _on_animation_player_animation_finished(anim_name):
	if anim_name=="attack_end":
		behavior.stop=false
		#behavior.anim.active=true
		master.axis_lock_angular_y=false
		
		#can_attack=true
