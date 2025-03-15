extends Node3D

func _ready() -> void:
	spawn_altars()

func spawn_altars():
	var altar_scene = preload("res://Scenes/shop_altar.tscn")

	# Primer altar
	var altar_instance1 = altar_scene.instantiate()
	altar_instance1.position = Vector3(0.851, -0.189, 1.959)
	altar_instance1.name = "Altar1"  # Asignar un nombre único
	add_child(altar_instance1)

	# Segundo altar
	var altar_instance2 = altar_scene.instantiate()
	altar_instance2.position = Vector3(0.851, -0.189, -1.845)
	altar_instance2.name = "Altar2"  # Asignar un nombre único
	add_child(altar_instance2)
