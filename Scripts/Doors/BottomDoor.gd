extends Area3D

var doorsOpen = false
var current_pos

func _ready() -> void:
	current_pos = [Global.playerMapPositionX, Global.playerMapPositionY]
	if current_pos in Global.rooms_visited or Global.enemies_remaining == 0:
		$Trunk.visible = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		
		 #Mete en el array de salas vistas la habitacion en la que acabas de estar
		if current_pos not in Global.rooms_visited:
			Global.rooms_visited.append(current_pos)
			
		Global.playerMapPositionX += 1
		Global.eraseLevel = true
		Global.playerDirection = 1 #abajo (saldra por abajo en la sigente sala)


func _process(delta):
	if Global.enemies_remaining == 0:
		if doorsOpen == false:
			$AnimationPlayer.play("BlockDoor")
			doorsOpen = true
	if Global.eraseLevel == true:
		queue_free()
