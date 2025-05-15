extends Control

@onready var resumeButton = $ColorRect/Resume

func _ready():
	position.x = -800
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func pause():
	Global.is_game_paused = true
	get_tree().paused = true
	
	self.show()
	
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position:x", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func resume():
	Global.card_focused = false
	
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position:x", -800, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(func(): 
		Global.is_game_paused = false
		get_tree().paused = false
		self.hide()
	)

func testEsc():
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		resumeButton.grab_focus()
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
		
func _on_resume_pressed():
	resume()

func _on_exit_pressed():
	get_tree().quit()

func _process(_delta):
	testEsc()
