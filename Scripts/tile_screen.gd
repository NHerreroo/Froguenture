extends Node3D

func _ready() -> void:
	$AnimationPlayer2.play("in")
	$AnimationPlayer.play("entry")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/run.tscn")

func _on_continue_pressed() -> void:
	# 1. Primero verifica explícitamente el árbol de escenas
	var scene_tree = get_tree()
	if not scene_tree:
		printerr("Error: El árbol de escenas no está disponible")
		return
	
	# 2. Carga la partida
	if not SaveSystem.load_game():
		printerr("Error al cargar la partida")
		return
	
	# 3. Usa call_deferred para cambiar de escena en el momento seguro
	scene_tree.call_deferred("change_scene_to_file", "res://Scenes/Lobby.tscn")
