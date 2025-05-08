extends Node

@onready var label = $SubViewport/MarginContainer/MarginContainer/Label

var lines: Array = []
var current_line := 0
var char_index := 0
var is_typing := false

var typing_speed := 0.03

var typing_timer: Timer

func _ready():
	typing_timer = Timer.new()
	typing_timer.one_shot = true
	typing_timer.wait_time = typing_speed
	add_child(typing_timer)
	typing_timer.timeout.connect(_on_typing_timer_timeout)

func start_dialog(path: String) -> void:
	if Global.dialog_ended == true:
		self.visible = true
		Global.dialog_ended = false
		lines.clear()
		current_line = 0
		char_index = 0

		var file := FileAccess.open(path, FileAccess.READ)
		if file:
			while not file.eof_reached():
				var line = file.get_line()
				line = line.replace("\\n", "\n")
				lines.append(line)
			file.close()

			# Elimina la última línea si está vacía (muy común en .txt)
			if lines.size() > 0 and lines[-1].strip_edges() == "":
				lines.pop_back()

			# Si después de limpiar no hay nada, oculta el diálogo
			if lines.is_empty():
				self.visible = false
				Global.dialog_ended = true
				return

			show_next_line()
		else:
			self.visible = true


func show_next_line():
	if current_line == lines.size():
		self.visible = false
		Global.dialog_ended = true
	if current_line < lines.size():
		label.text = ""
		char_index = 0
		is_typing = true
		typing_timer.start()

func _on_typing_timer_timeout():
	if current_line >= lines.size():
		return

	var line = lines[current_line]
	if char_index < line.length():
		label.text += line[char_index]
		char_index += 1
		typing_timer.start()
		$Speak.pitch_scale = randf_range(0.9, 1.1)
		$Speak.play()
	else:
		is_typing = false
		current_line += 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Confirm") and not event.is_echo():
		if is_typing:
			# Mostrar línea completa de inmediato si el jugador pulsa durante el tipeo
			label.text = lines[current_line]
			char_index = lines[current_line].length()
			is_typing = false
			current_line += 1
		else:
			show_next_line()
			$Accept.play()
