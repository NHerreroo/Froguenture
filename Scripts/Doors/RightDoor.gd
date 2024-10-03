extends Area3D


func _on_body_entered(body):
	if body.is_in_group("player"):
		print("rigthdoordetected")
		Global.playerMapPositionY += 1
		Global.eraseLevel = true
		
func _process(delta):
	if Global.eraseLevel == true:
		queue_free()
