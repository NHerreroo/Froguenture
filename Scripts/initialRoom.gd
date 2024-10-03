extends Node3D


func _process(delta):
	if Global.eraseLevel == true:
		queue_free()
