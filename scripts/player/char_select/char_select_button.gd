class_name Char_Select_Button
extends Button

@export var selector:Char_Selector
@export var char_id:int = 0
@export var char_name:String = "char"
@export_multiline var char_desc:String = "char"
@export var ablt_name:String = "ability"
@export_multiline var ablt_desc:String = "ability"
@export var bust: AnimatedSprite2D 
@export var bg_color:Color

func _ready():
	bust.visible=false
#
func _process(_delta):
	if is_hovered() and !selector.has_chosen or has_focus() and !selector.has_chosen :
		if !has_focus():grab_focus()
		bust.visible=true
		bust.play()
		selector.chosen_char_id=char_id
		selector.char_name=char_name
		selector.char_desc=char_desc
		selector.char_abl_name=ablt_name
		selector.char_abl_desc=ablt_desc
		selector.fill_name_texts()
		selector.av_gradient_bg.modulate.r=bg_color.r
		selector.av_gradient_bg.modulate.g=bg_color.g
		selector.av_gradient_bg.modulate.b=bg_color.b
		selector.av_gradient_bg.modulate.a=bg_color.a
	elif selector.has_chosen and selector.selected_btn==self:
		bust.visible=true
		selector.av_gradient_bg.modulate.r=bg_color.r
		selector.av_gradient_bg.modulate.g=bg_color.g
		selector.av_gradient_bg.modulate.b=bg_color.b
		selector.av_gradient_bg.modulate.a=bg_color.a
	else:
		#selector.av_gradient_bg.modulate.a=0
		bust.visible=false

func _on_pressed():
	selector.chosen_char_id=char_id
	selector.char_name=char_name
	selector.char_desc=char_desc
	selector.char_abl_name=ablt_name
	selector.char_abl_desc=ablt_desc
	selector.selected_btn=self
	selector.fill_name_texts()
	if !selector.has_chosen: selector.has_chosen=true
