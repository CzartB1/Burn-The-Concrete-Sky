class_name Char_Select_Button
extends TextureButton

@export var selector:Char_Selector
@export var char_id:int = 0
@export var char_name:String = "char"
@export_multiline var char_desc:String = "char"
@export var ablt_name:String = "ability"
@export_multiline var ablt_desc:String = "ability"
@export_group("Colors")
@export_color_no_alpha var normal_color:Color = Color.WHITE
@export_color_no_alpha var hover_color:Color = Color.DARK_GRAY
@export_color_no_alpha var press_color:Color = Color.RED

#func _ready():
	#text = char_name
#
func _process(_delta):
	if is_hovered() and !selector.has_chosen:
		modulate=hover_color
		selector.chosen_char_id=char_id
		selector.char_name=char_name
		selector.char_desc=char_desc
		selector.char_abl_name=ablt_name
		selector.char_abl_desc=ablt_desc
		selector.fill_name_texts()
	elif selector.has_chosen and selector.selected_btn==self:
		modulate=press_color
	else:
		modulate=normal_color

func _on_pressed():
	selector.chosen_char_id=char_id
	selector.char_name=char_name
	selector.char_desc=char_desc
	selector.char_abl_name=ablt_name
	selector.char_abl_desc=ablt_desc
	selector.selected_btn=self
	selector.fill_name_texts()
	if !selector.has_chosen: selector.has_chosen=true
