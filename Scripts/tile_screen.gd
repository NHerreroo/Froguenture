extends Node3D

var options = preload("res://Scenes/Options.tscn")

func _ready():
	if not SaveSystem.load_config():  
		print("No Exsiste la config")
		SaveSystem.save_config()
	else:
		print("cargando la configuracion")
	
	_apply_audio_settings()
	$AudioStreamPlayer.play()
	$ColorRect2/AnimationPlayer.play("in")
	$AnimationPlayer2.play("in")
	$AnimationPlayer.play("entry")


func musicFade():
	while $AudioStreamPlayer.volume_db > -50:
		$AudioStreamPlayer.volume_db -= 1
		await get_tree().create_timer(0.01).timeout
		
func _on_button_pressed() -> void:
	musicFade()
	$ColorRect2/AnimationPlayer.play("out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/run.tscn")

func _on_continue_pressed() -> void:
	musicFade()
	await get_tree().create_timer(1).timeout
	var scene_tree = get_tree()
	if not scene_tree:
		printerr("Error: El árbol de escenas no está disponible")
		return

	if not SaveSystem.load_game():
		printerr("Error al cargar la partida")
		return
		
	$ColorRect2/AnimationPlayer.play("out")
	await get_tree().create_timer(1).timeout
	scene_tree.call_deferred("change_scene_to_file", "res://Scenes/Lobby.tscn")


func spawnOptions():
	var newOptions = options.instantiate()
	add_child(newOptions)


func _on_options_pressed() -> void:
	spawnOptions()


func _on_exit_pressed() -> void:
	get_tree().quit()
	
	
func _apply_audio_settings():
	_set_bus_volume("Master", Config.master)
	_set_bus_volume("Music", Config.music)
	_set_bus_volume("SFX", Config.sfx)

func _set_bus_volume(bus_name: String, value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), db)


func _on_itchi_pressed() -> void:
	OS.shell_open("https://nacho-herrero.itch.io")


func _on_insta_pressed() -> void:
	OS.shell_open("https://www.instagram.com/___nachetee12/")



func _on_x_pressed() -> void:
	OS.shell_open("https://x.com/_nachetee")
