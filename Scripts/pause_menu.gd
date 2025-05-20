extends CanvasLayer

@onready var resumeButton = $ColorRect/Resume
@onready var colorRect = $ColorRect

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	colorRect.position.x = -800
	hide()
	
func pause():
	Global.is_game_paused = true
	get_tree().paused = true
	
	self.show()
	
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(colorRect, "position:x", -200, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func resume():
	Global.card_focused = false
	
	var tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(colorRect, "position:x", -800, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
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

func _process(delta):
	testEsc()
