extends Node3D
	
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
	Global.treasureItem = null
	Global.treasureItemPurchased = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
			Player.notifyTransition()
			await get_tree().create_timer(0.5).timeout
			reset_globals_set_def_stats()
			Events.emit_signal("level_done")
