extends Node3D


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	Player.setBaseStats()
	
func _process(delta: float) -> void:
		Global.runEnded = true
		Engine.time_scale = 1
	
func _on_button_pressed() -> void:
		SaveSystem.save_game()
