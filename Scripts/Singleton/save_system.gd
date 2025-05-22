extends Node

const SAVE_PATH = "user://savegame.dat"
const CONFIG_PATH = "user://config.dat"

func save_game():
	var save_data = {
		"totalSeeds": Global.totalSeeds,
		"totalTime": Global.totalTime,
		"totalKills": Global.totalKills,
		"totalRuns": Global.totalRuns,
		"totalFloors": Global.totalFloors,
		"is_in_tutorial": Global.is_in_tutorial
	}
	
	# Obtener y mostrar la ruta completa
	var global_path = ProjectSettings.globalize_path(SAVE_PATH)
	print("Intentando guardar en:", global_path)
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_data)
		file.close()
		print("Partida guardada correctamente en:", global_path)
	else:
		print("Error al guardar. Código de error:", FileAccess.get_open_error())
		print("Ruta intentada:", global_path)

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No hay partida guardada")
		return false
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var save_data = file.get_var()
		file.close()
		
		# Asignar los valores cargados a las variables globales
		Global.totalSeeds = save_data.get("totalSeeds", 0)
		Global.totalTime = save_data.get("totalTime", 0)
		Global.totalKills = save_data.get("totalKills", 0)
		Global.totalRuns = save_data.get("totalRuns", 0)
		Global.totalFloors = save_data.get("totalFloors", 0)
		Global.is_in_tutorial = save_data.get("is_in_tutorial", true)
		
		print("Partida cargada correctamente")
		return true
	else:
		print("Error al cargar: ", FileAccess.get_open_error())
		return false

func delete_save():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("Partida eliminada")
		return true
	return false
	
	
	
#sistema de guardado para la configuracion esto se guarda solo y se carga al incio del juego
func save_config():
	var config_data = {
		"master": Config.master,
		"music": Config.music,
		"sfx": Config.sfx
	}

	var path = ProjectSettings.globalize_path(CONFIG_PATH)
	print("Guardando configuración en:", path)

	var file = FileAccess.open(CONFIG_PATH, FileAccess.WRITE)
	if file:
		file.store_var(config_data)
		file.close()
		print("Configuración guardada correctamente")
	else:
		print("Error al guardar configuración:", FileAccess.get_open_error())

func load_config():
	if not FileAccess.file_exists(CONFIG_PATH):
		print("No hay configuración guardada")
		return false

	var file = FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file:
		var config_data = file.get_var()
		file.close()

		Config.master = config_data.get("master", 0.1)
		Config.music = config_data.get("music", 0.1)
		Config.sfx = config_data.get("sfx", 0.1)

		print("Configuración cargada correctamente")
		return true
	else:
		print("Error al cargar configuración:", FileAccess.get_open_error())
		return false

func delete_config():
	if FileAccess.file_exists(CONFIG_PATH):
		DirAccess.remove_absolute(CONFIG_PATH)
		print("Configuración eliminada")
		return true
	return false
