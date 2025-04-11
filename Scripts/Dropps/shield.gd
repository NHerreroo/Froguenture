extends Area3D

var is_from_persistence := false  # Marcar si este ítem ya está registrado

func _ready() -> void:
	if not is_from_persistence:
		Global.add_item_to_room(
			Global.playerMapPositionX,
			Global.playerMapPositionY,
			"Shield",
			position
		)

	Events.room_exited.connect(_on_room_exited)


func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.remove_item_from_room(
			Global.playerMapPositionX,
			Global.playerMapPositionY,
			position
		)
		Player.shield += 1.0
		Player.notify_health_updated()
		queue_free()

func _on_room_exited():
	queue_free()


func _process(delta):
	var x = Global.playerMapPositionX
	var y = Global.playerMapPositionY
	var my_room = Vector2(round(position.x), round(position.z))

	if not is_inside_current_room(x, y):
		queue_free()

func is_inside_current_room(x, y):
	return true  # Placeholder
