extends Label

# Actualiza la información de debug cada frame
func _process(delta):
	# FPS
	var fps = Engine.get_frames_per_second()
	# VRAM en MB
	var vram_usage = OS.get_static_memory_usage() / 1024 / 1024
	# Temperatura de la CPU (puede depender de tu hardware y sistema operativo, por lo que puede devolver 0 en algunos casos)
	
	# Actualiza el texto del Label
	text = "=== DEBUG INFO ===\n"
	text += "FPS: %d\n" % fps
	text += "VRAM: %.2f MB\n" % vram_usage
	text += "Enemigos Rest:" + str(Global.enemies_remaining) + "\n" 
