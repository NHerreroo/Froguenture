extends Node3D

func _process(delta):
	if Global.eraseLevel == true:
		queue_free()

func _ready():
	await get_tree().create_timer(4).timeout
	$AnimationPlayer.play("fade")
	await get_tree().create_timer(1).timeout
	queue_free()
