extends Control

@onready var resumeButton = $PanelContainer/BoxContainer/Resume

func pause():
	Global.is_game_paused = true
	self.show()
	get_tree().paused = true

func resume():
	Global.card_focused = false #para evitar eprdier focus de la carta si pausas menu en item selection
	Global.is_game_paused = false
	self.hide()
	get_tree().paused = false


func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		resumeButton.grab_focus()
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
		
func _on_resume_pressed():
	resume()

func _on_exit_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()


func _on_check_box_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
