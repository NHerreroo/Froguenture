extends Control

@onready var resumeButton = $PanelContainer/BoxContainer/Resume

func resume():
	self.hide()
	get_tree().paused = false

func pause():
	self.show()
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		resumeButton.grab_focus()
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resumeButton.grab_focus()
		resume()
		
func _on_resume_pressed():
	resume()

func _on_exit_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()
