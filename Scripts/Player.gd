extends CharacterBody3D

var pauseMenu = preload("res://Scenes/pause_menu.tscn")

const SPEED = 5.0
const LERP_AMOUNT = 0.4  # Controla la suavidad del movimiento

var current_animation = ""


func _physics_process(delta):

	# Get the input direction and handle the movement.
	var input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Aplica lerp para suavizar el movimiento en los ejes X y Z
	velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_AMOUNT)
	velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_AMOUNT)

	move_and_slide()
	
	
	#me detecta la tecla de direccion y llama a la func que me hace la animación pasandole el nombre de la anim
	if Input.is_action_pressed("Keyboard_D"):
		play_animation("walk_right")
	elif Input.is_action_pressed("Keyboard_A"):
		play_animation("walk_left")
	elif Input.is_action_pressed("Keyboard_W"):
		play_animation("up")
	elif Input.is_action_pressed("Keyboard_S"):
		play_animation("down")
	else:
		play_animation("idle")

# func para  la animación si no está ya en reproducción
func play_animation(anim_name: String):
	if current_animation != anim_name:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name
