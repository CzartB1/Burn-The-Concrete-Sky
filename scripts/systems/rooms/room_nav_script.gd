extends NavigationRegion3D

@export var room: Room

func _process(_delta):
	if room == null:
		if get_parent_node_3d() == Room:
			room = get_parent_node_3d()
		elif get_parent_node_3d() == Room:
			printerr("nav in current room is null and can't find room D:")
