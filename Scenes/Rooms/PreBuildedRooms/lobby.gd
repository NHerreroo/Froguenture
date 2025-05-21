extends Node3D


func _ready() -> void:
	Player.setBaseStats()
	Player.notify_health_updated()
	
func _process(delta: float) -> void:
		Global.runEnded = true
		Engine.time_scale = 1
	
func _on_button_pressed() -> void:
		SaveSystem.save_game()
