extends Area3D

func _ready() -> void:
	$Trunk.visible = true
	Global.botCollider = true

func _process(delta):
	if Global.eraseLevel == true:
		Global.leftCollider = false
		Global.rightCollider = false
		queue_free()
