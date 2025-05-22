extends Control

func _ready() -> void:
	$AnimationPlayer.play("entry")
	
func changeToTitle():
	get_tree().change_scene_to_file("res://Scenes/TtleScreen.tscn")
