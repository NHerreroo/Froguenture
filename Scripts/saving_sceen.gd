extends Control

func _ready() -> void:
	Global.persistent_items.clear()
	Global.totalTime += Global.run_time
	Global.totalKills += Global.run_total_kills
	Global.totalFloors += Global.lvlCount
	
	await SaveSystem.save_game()
	
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
	
