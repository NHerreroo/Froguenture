extends Area3D

var doorsOpen = false
var current_pos

func _ready() -> void:
	current_pos = [Global.playerMapPositionX, Global.playerMapPositionY]
	if current_pos in Global.rooms_visited or Global.enemies_remaining == 0:
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
		Global.enemies_remaining = 0
		 #Mete en el array de salas vistas la habitacion en la que acabas de estar
		if current_pos not in Global.rooms_visited:
			Global.rooms_visited.append(current_pos)

		Player.notifyTransition()
		await get_tree().create_timer(0.2).timeout
		Global.playerMapPositionY += 1
		Events.room_exited.emit()
		Global.eraseLevel = true
		Global.playerDirection = 3 #arriba (saldra por arriba en la sigente sala)
		
