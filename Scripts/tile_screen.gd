extends Node3D

var options = preload("res://Scenes/Options.tscn")

func _ready() -> void:
	$AnimationPlayer2.play("in")
	$AnimationPlayer.play("entry")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/run.tscn")

func _on_continue_pressed() -> void:
	var scene_tree = get_tree()
	if not scene_tree:
		printerr("Error: El árbol de escenas no está disponible")
		return

	if not SaveSystem.load_game():
		printerr("Error al cargar la partida")
		return
	
	scene_tree.call_deferred("change_scene_to_file", "res://Scenes/Lobby.tscn")


func spawnOptions():
	var newOptions = options.instantiate()
	add_child(newOptions)


func _on_options_pressed() -> void:
	spawnOptions()


func _on_exit_pressed() -> void:
	get_tree().quit()
