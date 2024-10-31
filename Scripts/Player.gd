extends CharacterBody3D

var pauseMenu = preload("res://Scenes/pause_menu.tscn")

const SPEED = 5.0
const DASH_SPEED = 20.0  
const DASH_DURATION = 0.28  
const DASH_COOLDOWN = 1.0 

const LERP_AMOUNT = 0.4
const DASH_LERP_AMOUNT = 0.15

var current_animation = ""

# Variables para el dash
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector3.ZERO


func _ready():
	setPlayerPosition(Global.playerDirection)
	
func setPlayerPosition(position: int):
	match position:
		0: #arriba
			self.position = Vector3(4.038,0.014,-0.207) 
		1: #abajo
			self.position = Vector3(-3.962,0.014,-0.207)
		2: #Izqui
			self.position = Vector3(0.038, 0.014, -7.707)
		3: #derch
			self.position = Vector3(0.038,0.014,7.793)
		4: #mitad (solo inicio partida)
			self.position = Vector3(2.638, 0.014, -0.207)
	
func _physics_process(delta):
	var input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	perform_dash(delta, direction)
	
	# Movimiento normal solo si no está en dash
	if not is_dashing:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_AMOUNT)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_AMOUNT)

	if Global.can_walk:
		# Detecta la tecla de dirección y llama a la función de animación
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
		
		Global.CurrentPlayerPosition = Vector2(self.position.x, self.position.y)
		
		move_and_slide()  # Mueve al personaje

# Función modular para manejar el dash con lerp
func perform_dash(delta, direction):
	if is_dashing:
		# Aplica el lerp para hacer la transición suave hacia el dash
		velocity.x = lerp(velocity.x, dash_direction.x * DASH_SPEED, DASH_LERP_AMOUNT)
		velocity.z = lerp(velocity.z, dash_direction.z * DASH_SPEED, DASH_LERP_AMOUNT)
		
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false  # Termina el dash
			velocity = Vector3.ZERO  # Detiene la velocidad de dash
	elif dash_cooldown_timer <= 0 and Input.is_action_just_pressed("dash"):
		# Iniciar el dash
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		dash_direction = direction  # La dirección del dash es la actual del personaje

	# Actualizar el cooldown del dash
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

# Función para la animación si no está ya animándose
func play_animation(anim_name: String):
	if current_animation != anim_name:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name
