class_name Music_Manager
extends AudioStreamPlayer

@export var music_transition_speed=0.7
@export var score_to_transition=7
@export var manager:Room_manager
var plr: Player
var combat=false
var ambient=false
var rest=false

func _ready():
	get_stream_playback().switch_to_clip_by_name("Ambient")

func _process(delta): #TODO music for death and char select
	pitch_scale/=Engine.time_scale
	if plr == null:
		var plr_check = get_tree().get_first_node_in_group("Player")
		if plr_check is Player:
			plr = plr_check
	if game_manager.in_battle:
		if !combat:
			if stream.get_clip_stream(1).instantiate_playback() is AudioStreamPlaybackInteractive:
				#HACK copy this code for rest,ambient, and boss music
				stream.get_clip_stream(1).initial_clip=plr.combat_music_index 
				#Just changing the initial clip cuz godot hasn't added a good way to replace a clip in audiostreaminteractive
				#I'm sweatin, cryin, shittin, pissin, vomitin, lactatin, and cummin right now
			if manager.current_room_category==1:
				get_stream_playback().switch_to_clip(1)
			elif manager.current_room_category==4:
				get_stream_playback().switch_to_clip(2)
			combat=true
			ambient=false
			rest=false
	elif !game_manager.in_battle: 
		if manager.current_room_category==1:
			if !ambient:
				get_stream_playback().switch_to_clip(0)
				combat=false
				ambient=true
				rest=false
		elif manager.current_room_category==2:
			if !rest:
				get_stream_playback().switch_to_clip(3)
				combat=false
				ambient=false
				rest=true

#func force_play_music(music:AudioStream): #TODO fix this and the one in the boss room script
	#var battle_music_volume=create_tween()
	#var calm_music_volume=create_tween()
	#battle_music.stream=music
	#battle_music.play()
	#battle_music_volume.tween_property($battle_music, "volume_db", 0,music_transition_speed)
	#calm_music_volume.tween_property($calm_music, "volume_db", -80,music_transition_speed)
	#await get_tree().create_timer(music_transition_speed).timeout
	#calm_music.stop()
