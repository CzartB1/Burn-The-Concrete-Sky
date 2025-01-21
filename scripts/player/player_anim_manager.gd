extends AnimationTree

@export var master:Player
@export var body:Node3D
var move_dir:int
var move_look_diff

func _process(_delta): # If animation wont start/seems paused, check blender to see if the armature is in rest pose. If yes, disable the rest pose
	if master.alive:
		check_move_dir()
		move_look_diff = move_dir-int(body.rotation_degrees.y)
		#print("differences: " + str(move_look_diff))
		if master.velocity != Vector3.ZERO:
			move_diff_check()
		elif master.velocity == Vector3.ZERO:
			set("parameters/BlendSpace2D/blend_position",Vector2(0,0))

func check_move_dir():
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#print(dir)
	
	if dir.y<-.5:
		move_dir = 0
		if dir.x<-.5:
			move_dir=45
		elif dir.x>.5:
			move_dir=-45
	elif dir.y>.5:
		move_dir = 180
		if dir.x<-.5:
			move_dir=135
		elif dir.x>.5:
			move_dir=-135
	elif dir.y>-.5 and dir.y<.5:
		if dir.x<-.5:
			move_dir=90
		elif dir.x>.5:
			move_dir=-90
	#print(move_dir)

func move_diff_check():
	if move_look_diff < 22.5 and move_look_diff > -22.5: # forward
		set("parameters/BlendSpace2D/blend_position",Vector2(0,1))
		#print("forward")
	elif move_look_diff > 22.5 and move_look_diff < 62.5: # forward left
		#print("forward left")
		set("parameters/BlendSpace2D/blend_position",Vector2(.5,.5))
		pass
	elif move_look_diff < -22.5 and move_look_diff > -62.5: # forward right
		#print("forward right")
		set("parameters/BlendSpace2D/blend_position",Vector2(-.5,.5))
		pass
	elif move_look_diff < 112.5 and move_look_diff > 62.5: # left
		#print("left")
		set("parameters/BlendSpace2D/blend_position",Vector2(1,0))
		pass
	elif move_look_diff > -112.5 and move_look_diff < -62.5: # right
		#print("right")
		set("parameters/BlendSpace2D/blend_position",Vector2(-1,0))
		pass
	elif move_look_diff > 112.5 and move_look_diff < 157.5: # backward left
		#print("backward left")
		set("parameters/BlendSpace2D/blend_position",Vector2(.5,-.5))
		pass
	elif move_look_diff < -112.5 and move_look_diff > -157.5: # backward right
		#print("backward right")
		set("parameters/BlendSpace2D/blend_position",Vector2(-.5,-.5))
		pass
	elif move_look_diff > 157.5 or move_look_diff < -157.5: # backward
		set("parameters/BlendSpace2D/blend_position",Vector2(0,-1))
		#print("backward")
