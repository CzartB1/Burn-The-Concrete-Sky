class_name Char_Selector
extends Control

@export var room_manager: Room_manager
@export var characters: Array[PackedScene]
@export var name_text:RichTextLabel
@export var desc_text:RichTextLabel
@export var abl_text:RichTextLabel
var has_chosen = false
var chosen_char_id:int
var char_name:String
var char_desc:String
var char_abl_name:String
var char_abl_desc:String
var selected_btn:Char_Select_Button
var spawned=false

func ready():
	if !game_manager.show_char_select:
		hide()
	elif game_manager.show_char_select:
		show()
	
	game_manager.char_selection=characters

func _process(_delta):
	if game_manager.show_char_select:
		return
		#if has_chosen:
			#print(str(char_name) + " " + str(char_desc))
			#fill_name_texts()
	elif !game_manager.show_char_select:
		visible = false
		var instance = characters[game_manager.current_char_id].instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = Vector3.ZERO
		room_manager.start()
		game_manager.start_count_time()
		var tr=get_tree().get_first_node_in_group("Transition")
		if tr is AnimationPlayer: tr.play("fade_in")
		queue_free()
	
	if selected_btn: selected_btn.modulate=selected_btn.press_color

func fill_name_texts():
	name_text.text = "[b]"+str(char_name)+"[/b]"
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
		visible = false
		var tr=get_tree().get_first_node_in_group("Transition")
		if tr is AnimationPlayer: tr.play("fade_in")
		queue_free()

func spawn_character(id:int): #FIXME still sometimes spawn 2 characters. Maybe add a bool that tells if one had spawned or not
	if spawned: return
	spawned=true
	var instance = characters[id].instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = Vector3.ZERO
	room_manager.start()
