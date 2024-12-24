extends Area3D

var doorsOpen = false

func _ready() -> void:
	if Global.enemies_remaining == 0:
		$Trunk.visible = false
		
func _process(delta):
	if Global.enemies_remaining == 0:
		if doorsOpen == false:
			$AnimationPlayer.play("BlockDoor")
			doorsOpen = true
	if Global.eraseLevel == true:
		queue_free()
		
func _on_body_entered(body):
	if body.is_in_group("player"):
		#print("topdoordetected")
		Global.playerMapPositionX -= 1
		Global.eraseLevel = true
		Global.playerDirection = 0 #arriba (saldra por arriba en la sigente sala)
