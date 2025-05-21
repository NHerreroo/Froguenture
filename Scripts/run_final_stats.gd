extends Control

func _ready() -> void:
	$AnimationPlayer.play("in")
	$CanvasLayer/ColorRect3/AnimationPlayer.play("transparent")
	# Mostrar el tiempo formateado
	$CanvasLayer/Control/Time.text = "Time: " + format_time(Global.run_time)
	$CanvasLayer/Control/Kills.text = "Total Kills: " + str(Global.run_total_kills)

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
	$CanvasLayer/ColorRect3/AnimationPlayer.play("out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
