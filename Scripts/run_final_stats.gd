extends Control

func _ready() -> void:
	# Mostrar el tiempo formateado
	$CanvasLayer/Time.text = "Time: " + format_time(Global.run_time)
	$CanvasLayer/Kills.text = "Total Kills: " + str(Global.run_total_kills)

	#Global.totalSeeds = 0
	Global.totalTime += Global.run_time
	Global.totalKills += Global.run_total_kills
	Global.totalSeeds +=  1
	Global.totalFloors += Global.lvlCount

# Función para convertir segundos a MM:SS
func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var remaining_seconds = int(seconds) % 60
	return "%02d:%02d" % [minutes, remaining_seconds]


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
