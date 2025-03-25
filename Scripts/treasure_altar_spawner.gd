extends Node3D

func _ready() -> void:
	spawn_altars()

func spawn_altars():
	var altar_scene = preload("res://Scenes/treasure_altar.tscn")

	# Primer altar
	var altar_instance = altar_scene.instantiate()
	altar_instance.position = Vector3(0.851, -0.189, 1.959)
	add_child(altar_instance)
