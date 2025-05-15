extends Control

func _ready() -> void:
	# Mostrar el tiempo formateado
	$Time.text = "Time: " + format_time(Global.run_time)
	$Kills.text = "Total Kills: " + str(Global.run_total_kills)

# Función para convertir segundos a MM:SS
func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var remaining_seconds = int(seconds) % 60
	return "%02d:%02d" % [minutes, remaining_seconds]


func _on_button_pressed() -> void:
	Global.runEnded = true
	Events.emit_signal("level_done")
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
