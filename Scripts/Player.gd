extends CharacterBody3D

var pauseMenu = preload("res://Scenes/pause_menu.tscn")

const SPEED = 5.0
const LERP_AMOUNT = 0.4  # Controla la suavidad del movimiento
const MESH_DISTANCE = 1.5  # Distancia del MeshInstance al personaje

var current_animation = ""
var mesh_instance: MeshInstance3D  # Variable para el MeshInstance

func _ready():
	mesh_instance = $atack  # Asumiendo que el MeshInstance está como hijo del personaje
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
	# Get the input direction and handle the movement.
	var input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Aplica lerp para suavizar el movimiento en los ejes X y Z
	velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_AMOUNT)
	velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_AMOUNT)
	
	if Global.can_walk:
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
		
		move_and_slide() #mueve al pers

# Func para la animación si no está ya animandose
func play_animation(anim_name: String):
	if current_animation != anim_name:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name
