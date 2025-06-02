extends Node2D

func _ready() -> void:
	await  get_tree().create_timer(1).timeout
	$AnimationPlayer.play("credits")
	await  get_tree().create_timer(30).timeout
	get_tree().change_scene_to_file("res://Scenes/TtleScreen.tscn")
