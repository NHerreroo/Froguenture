extends Node3D

var player = null

func _process(delta):
	if Global.eraseLevel == true:
		queue_free()
