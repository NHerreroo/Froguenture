extends Node3D


func _ready() -> void:
	Global.runEnded = true
	Engine.time_scale = 1
	Player.setBaseStats()
	
func _on_run_pressed() -> void:
	Global.resetall()
	get_tree().change_scene_to_file("res://Scenes/run.tscn")


func _on_button_pressed() -> void:
		SaveSystem.save_game()
