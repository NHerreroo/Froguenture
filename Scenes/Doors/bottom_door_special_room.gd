extends Area3D

func _ready() -> void:
	$Trunk.visible = true
	Global.botCollider = true

func _process(delta):
	if Global.eraseLevel == true:
		Player.notifyTransition()
		await get_tree().create_timer(0.2).timeout
		Global.leftCollider = false
		Global.rightCollider = false
		queue_free()
