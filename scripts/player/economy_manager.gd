class_name Player_Economy_Manager
extends Node3D

@export var money:int
@export var money_label:RichTextLabel
@export var money_timer:Timer
@export var multiplier_label:RichTextLabel
@export var multiplier_timer_bar:ProgressBar
@export var explosion_effect:AnimatedSprite2D
@export var anim:AnimationPlayer
var multiplier:float=1

func _ready():
	hide_money()
	hide_mult()

func _process(delta):
	money_label.text=str(money)
	multiplier_label.text="[center]"+str(multiplier)

	if multiplier_timer_bar.value>0:
		multiplier_timer_bar.value-=delta*(15*ceil(multiplier/5))
	elif multiplier_timer_bar.value<=0 and multiplier_timer_bar.visible:
		mult_reset()
		hide_mult()

func increase_money(amount:int): 
	money_label.show()
	money_timer.start()
	money+=int(float(amount)*multiplier)
	game_manager.stat_moneyearned+=int(float(amount)*multiplier)

func increase_mult(amount:float):
	explosion_effect.stop()
	anim.stop()
	multiplier_label.show()
	multiplier_timer_bar.show()
	multiplier+=amount
	multiplier_timer_bar.value=100
	explosion_effect.play("explode")
	anim.play("mult_add")
	if multiplier > game_manager.stat_highestmult:
		game_manager.stat_highestmult=multiplier

func mult_reset(play_anim:bool=false):
	multiplier=1
	if play_anim:
		anim.stop()
		anim.play("mult_reset")

func hide_money():
	money_label.hide()

func hide_mult():
	multiplier_label.hide()
	multiplier_timer_bar.hide()

func _on_money_label_timer_timeout():
	hide_money()
