extends Area3D

func _ready() -> void:
	$Trunk.visible = false

func _process(delta):
	if Global.eraseLevel == true:
		reset_globals_set_def_stats()
		Events.emit_signal("level_done")
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		Player.notifyTransition()
		await get_tree().create_timer(0.2).timeout
		Events.room_exited.emit()
		Global.eraseLevel = true


func reset_globals_set_def_stats():
	Global.isMapGenerated = false
	Global.playerMapPositionX = 25
	Global.playerMapPositionY = 25
	Global.eraseLevel = true
	Global.playerDirection = 4;
	Global.topCollider = false
	Global.botCollider = false
	Global.rightCollider = false
	Global.leftCollider = false
	Global.shopItem1 = null
	Global.shopItem2 = null
	Global.shopItem1Purchased = false
	Global.shopItem2Purchased = false
