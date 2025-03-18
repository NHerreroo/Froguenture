extends Node3D

func _ready() -> void:
	$AnimationPlayer.play("entry")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/run.tscn")
