extends CharacterBody3D

@export var speed = 40
@export var ray:RayCast3D
@export var line:Line_Renderer
var nearest_enemy:Enemy
var n_pos
var showline=false
var damage:int=100
var plr:Player
var multiplier:int = 3

func _ready():
	ray.enabled=false
	line.points[0]=Vector3.ZERO
	line.points[1]=Vector3.ZERO

func _process(delta):
	pass

func _physics_process(_delta):
	if speed > 0:
		velocity = global_transform.basis.z * -speed / Engine.time_scale
		speed-=2
	elif speed <= 0:
		velocity=Vector3.ZERO
	velocity.y=0
	move_and_slide()


func destroy_timer_timeout():
	queue_free()


#func _on_area_3d_body_entered(body): # FIXME WONT DETECT SHIT I DONT FUCKING KNOW WHY
	#print("coin shot")
	#if body is Player_Bullet:
		#damage=body.damage
		#coin_shot()
		#await get_tree().create_timer(.1*Engine.time_scale).timeout
		#queue_free()

func coin_shot(): #TODO make it so if there's another coin, it hits the coin instead of enemies. Kinda like in Ultrakill
	var enemies:Array = get_tree().get_nodes_in_group("Enemy")
	plr = get_tree().get_first_node_in_group("Player")
	print(str(enemies.size()))
	if enemies.size()!=0:
		nearest_enemy = enemies[0]
		for enemy in enemies:
			if enemy.global_position.distance_to(plr.global_position) < nearest_enemy.global_position.distance_to(plr.global_position):
				nearest_enemy = enemy
		showline=true
		line.points[0]=global_position
		line.points[1]=nearest_enemy.global_position
		nearest_enemy.take_damage(damage*multiplier) 
	elif enemies.size()==0:
		queue_free()


func _on_area_3d_area_entered(area):
	if area.get_parent_node_3d() is Player_Bullet:
		print("coin shot")
		damage=area.get_parent_node_3d().damage
		coin_shot()
		await get_tree().create_timer(.1*Engine.time_scale).timeout
		queue_free()
