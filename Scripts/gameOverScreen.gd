extends CanvasLayer

func _ready() -> void:
	$AnimationPlayer.play("in")
	await get_tree().create_timer(4).timeout
	await Global.resetall()
	await Player.setBaseStats()
	get_tree().change_scene_to_file("res://Scenes/savingSceen.tscn")
	
