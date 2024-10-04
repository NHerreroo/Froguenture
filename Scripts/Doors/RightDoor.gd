extends Area3D


func _on_body_entered(body):
	if body.is_in_group("player"):
		#print("rigthdoordetected")
		Global.playerMapPositionY += 1
		Global.eraseLevel = true
		Global.playerDirection = 3 #arriba (saldra por arriba en la sigente sala)
		
func _process(delta):
	if Global.eraseLevel == true:
		queue_free()
