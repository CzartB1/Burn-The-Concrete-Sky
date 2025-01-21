extends AudioStreamPlayer3D

var offset=0

func play_sound(sound_stream):
	stream=sound_stream
	play(offset)


func remove_self():
	queue_free()


func _on_finished():
	remove_self()
