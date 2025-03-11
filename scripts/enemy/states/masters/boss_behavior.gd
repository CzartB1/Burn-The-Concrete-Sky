extends Enemy_Behavior_Master

@export var phases:Array[Boss_Phase]
@export var current_phase:int
@export var health_bar:ProgressBar


func _ready():
	super._ready()
	health_bar.max_value=master.hp
	for i in phases:
		i.behavior=self

func _process(delta):
	super._process(delta)
	health_bar.value=master.hp
	#for s in phases.size()-1:
		#if phases[s].hp_to_activate >= master.hp:
			#current_phase=s #TO DO list the phase from highest hp_to_activate to lowest

func states():
	phases[current_phase].states()
	for p in phases.size()-1:
		if p==current_phase:
			phases[p].active=true
		elif p!=current_phase:phases[p].active=false
	#TODO attacks
	#TODO changing phases

func attack():
	phases[current_phase].perform_attack()
