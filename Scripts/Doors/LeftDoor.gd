extends Area3D


func _on_body_entered(body):
	if body.is_in_group("player"):
		#print("leftdoordetected")
		Global.playerMapPositionY -= 1
		Global.eraseLevel = true
		Global.playerDirection = 2 #izqu (saldra por izquierda en la sigente sala)

func _process(delta):
	if Global.eraseLevel == true:
		queue_free()
