class_name Char_Selector
extends Control

@export var room_manager: Room_manager
@export var focus_button:Button
@export var play_button:Button
@export var characters: Array[PackedScene]
@export var character_buttons: Array[Button]
@export var name_text:RichTextLabel
@export var name2_text:RichTextLabel
@export var desc_text:RichTextLabel
@export var abl_text:RichTextLabel
@export var av_gradient_bg:TextureRect
@export_group("Intro Sequence")
@export var intro_fall_sound:AudioStream
@export var before_fall_sfx_delay=0.8
@export var after_fall_sfx_delay=0.5
var audio_direct=preload("res://scene/utilities/audio_direct.tscn")
var has_chosen = false
var chosen_char_id:int
var char_name:String
var char_desc:String
var char_abl_name:String
var char_abl_desc:String
var selected_btn:Char_Select_Button
var spawned=false
var foc=false

func ready():
	if !game_manager.show_char_select:
		visible=false
	elif game_manager.show_char_select:
		visible=true
	
	av_gradient_bg.modulate.a=0
	game_manager.char_selection=characters


func _process(_delta):
	get_tree().get_first_node_in_group("diff_rating").update_rating(2)
	if game_manager.show_char_select:
		if focus_button!=null and !foc:
			if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				focus_button.grab_focus() #TODO make it so that the game remembers which icon was last focused, and make the play button's top focus the last focused icon
				foc=true
		update_top_neighbor()
		#if has_chosen:
			#print(str(char_name) + " " + str(char_desc))
			#fill_name_texts()
	elif !game_manager.show_char_select:
		visible = false
		var instance = characters[game_manager.current_char_id].instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = Vector3.ZERO
		await get_tree().create_timer(0.1).timeout
		game_manager.start_count_time()
		if !room_manager: room_manager=get_tree().get_first_node_in_group("room_manager")
		room_manager.start()
		intro_sequence()
	
	if has_chosen!=null and play_button:play_button.visible=has_chosen

func fill_name_texts():
	name_text.text = "[b]"+str(char_name)+"[/b]"
	name2_text.text = "[b]"+str(char_name)+"[/b]"
	desc_text.text = str(char_desc)
	abl_text.text = "[b]"+str(char_abl_name)+"[/b] - "+str(char_abl_desc)

func _on_done_button_pressed():
	if has_chosen and !spawned:
		spawned=true
		var instance = characters[chosen_char_id].instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = Vector3.ZERO
		
		var plrg:Array=get_tree().get_nodes_in_group("Player")
		if plrg.size()>1:
			for i in plrg.size()-1:
				if i > 0:
					plrg[i].queue_free()
		
		game_manager.current_char_id=chosen_char_id
		game_manager.show_char_select=false
		
		game_manager.start_count_time()
		room_manager.start()
		intro_sequence()

func spawn_character(id:int): #FIXME still sometimes spawn 2 characters. Maybe add a bool that tells if one had spawned or not
	if spawned: return
	spawned=true
	var instance = characters[id].instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = Vector3.ZERO
	room_manager.start()

func update_top_neighbor():
	var last_focused: Button = null
	for btn in character_buttons:
		if btn.has_focus() and play_button!=null:
			play_button.focus_neighbor_top = btn.get_path()
			break

func intro_sequence():
	visible = false
	var tr=get_tree().get_first_node_in_group("Transition")
	await get_tree().create_timer(before_fall_sfx_delay).timeout
	play_sound(intro_fall_sound)
	await get_tree().create_timer(after_fall_sfx_delay).timeout
	if tr is AnimationPlayer: tr.play("fade_in")
	var jus=get_tree().get_first_node_in_group("justicar")
	jus.finish_fade=true
	queue_free()

func play_sound(austr:AudioStream):
	if austr!=null:
		var audio=audio_direct.instantiate()
		add_child(audio)
		audio.play_sound(austr)
	elif !austr:
		print("sound not found")
