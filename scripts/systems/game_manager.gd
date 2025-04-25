extends Node

var show_char_select=true
var current_char_id:int
var stat_kills:int=0
var stat_roomcleared:int=0
var stat_moneyearned:int=0
var stat_highestmult:int=0
var stat_starttime:int=0
var stat_timenow:int=0
var time_count_stop=false
var paused:bool=false
var prev_timescale: float = 1.0
var char_selection:Array=[]
var time_slowed:bool=false
var in_battle:bool=false
var players_list:Array[Node]=[]

func _process(delta):
	players_list=get_tree().get_nodes_in_group("Player")
	if players_list.size()>1:for plr in players_list:if players_list.find(plr)>0: plr.queue_free()

# TODO show_char_select variable reset when exiting
func reset_stat():
	stat_kills=0
	stat_roomcleared=0
	stat_moneyearned=0
	stat_highestmult=0
	stat_starttime=0
	stat_timenow=0

func start_count_time():
	stat_starttime=ceili(Time.get_unix_time_from_system())
	time_count_stop=false

func stop_count_time():
	if !time_count_stop:
		stat_timenow=ceili(Time.get_unix_time_from_system()) #HACK maybe dont use unixtime cuz it fucks up when saving
		time_count_stop=true
	var elapsed = stat_timenow - stat_starttime
	var minutes = elapsed / 60
	var seconds = elapsed % 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	
	return str_elapsed

func restart(set_char_select: bool):
	# kill everything
	kill_all_enemies()
	var pl = get_tree().get_first_node_in_group("Player")
	if pl:
		pl.queue_free()
	# store your intent for new scene
	show_char_select = set_char_select
	# reset gameplay stats
	reset_stat()
	in_battle = false
	Engine.time_scale = 1.0
	AudioServer.playback_speed_scale = 1.0
	# reload
	get_tree().reload_current_scene()

func pause():
	prev_timescale = Engine.time_scale
	Engine.time_scale = 0
	paused = true

func unpause():
	Engine.time_scale = prev_timescale
	paused = false

func kill_all_enemies():
	var en=get_tree().get_nodes_in_group("Enemy")
	for i in en:
		i.queue_free()

func clean_effects():
	for e in get_tree().get_nodes_in_group("Effects"):
		e.queue_free()
