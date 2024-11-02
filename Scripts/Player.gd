extends CharacterBody3D

var pauseMenu = preload("res://Scenes/pause_menu.tscn")

const SPEED = 5.0
const DASH_SPEED = 20.0  
const DASH_DURATION = 0.28  
const DASH_COOLDOWN = 1.0

const LERP_AMOUNT = 0.4
const DASH_LERP_AMOUNT = 0.15
const MINI_DASH_SPEED = 10.0
const MINI_DASH_DURATION = 0.1

var current_animation = ""
var camera  # Variable para la cámara

# Variables para el dash
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector3.ZERO

# Variables para el mini-dash
var is_mini_dashing = false
var mini_dash_timer = 0.0
var mini_dash_direction = Vector3.ZERO

var can_atack = true
var attack_count = 0  # Contador de ataques en el combo


@onready var atackMesh = $AtackMesh

func _ready():
	setPlayerPosition(Global.playerDirection)

func _process(delta: float) -> void:
	camera = get_tree().get_root().find_child("Camera", true, false) #esto lo pongo aqui por que al cambiar de nivel tmb cambia de camara

func setPlayerPosition(position: int):
	match position:
		0: self.position = Vector3(4.038, 0.014, -0.207)  # arriba
		1: self.position = Vector3(-3.962, 0.014, -0.207) # abajo
		2: self.position = Vector3(0.038, 0.014, -7.707)  # izquierda
		3: self.position = Vector3(0.038, 0.014, 7.793)   # derecha
		4: self.position = Vector3(2.638, 0.014, -0.207)  # mitad (inicio partida)

func _physics_process(delta):
	
	var input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	perform_dash(delta, direction)
	
	# Prioridad para mini-dash
	if is_mini_dashing:
		perform_mini_dash(delta)
	else:
		# Movimiento normal si no hay dash activo
		if not is_dashing:
			velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_AMOUNT)
			velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_AMOUNT)
	
	# Control de acciones
	if Global.can_walk:
		# Animaciones de movimiento
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

		attack()
		move_and_slide()

# Dash principal
func perform_dash(delta, direction):
	if is_dashing:
		velocity.x = lerp(velocity.x, dash_direction.x * DASH_SPEED, DASH_LERP_AMOUNT)
		velocity.z = lerp(velocity.z, dash_direction.z * DASH_SPEED, DASH_LERP_AMOUNT)
		
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			velocity = Vector3.ZERO
	elif dash_cooldown_timer <= 0 and Input.is_action_just_pressed("dash"):
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		dash_direction = direction

	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

# Mini-dash en ataque
func perform_mini_dash(delta):
	velocity.x = lerp(velocity.x, mini_dash_direction.x * MINI_DASH_SPEED, LERP_AMOUNT)
	velocity.z = lerp(velocity.z, mini_dash_direction.z * MINI_DASH_SPEED, LERP_AMOUNT)
	
	mini_dash_timer -= delta
	if mini_dash_timer <= 0:
		is_mini_dashing = false

# Manejo de animaciones
func play_animation(anim_name: String):
	if current_animation != anim_name:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name

#----------------Funciones de ataque ------------------

func shoot_raycast() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_lenght = 1000
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_lenght
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	
	ray_query.from = from
	ray_query.to = to
	
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result:
		return raycast_result.position 
	else:
		return self.global_position  

func rotate_atack_mesh():
	var hit_position = shoot_raycast()  
	
	var direction_to_hit = (hit_position - self.global_position).normalized()
	direction_to_hit.y = 0 
	
	var mesh_offset = direction_to_hit * 1.5
	atackMesh.global_position = self.global_position + mesh_offset
	atackMesh.look_at(self.global_position, Vector3.UP)

func attack():
	if Input.is_action_just_pressed("atack") and can_atack:
		can_atack = false  # Desactiva el ataque temporalmente
		attack_count += 1  # Incrementa el contador de ataques en el combo
	
		if attack_count >= 3: #ataque pro (tercer ataque)
			perform_attack() 
			await get_tree().create_timer(Global.atackSpeed + 1).timeout
			can_atack = true
			attack_count = 0
		else:
			perform_attack()
			await get_tree().create_timer(Global.atackSpeed).timeout
			can_atack = true
			
			await get_tree().create_timer(1).timeout 
			if can_atack and attack_count < 3:
				attack_count = 0  #rompe el combo si estas 0.5 sin atacar


func perform_attack():
	rotate_atack_mesh()  # Orienta el ataque en dirección del raycast

	# Configura el mini-dash en dirección al impacto
	var hit_position = shoot_raycast()
	mini_dash_direction = (hit_position - self.global_position).normalized()
	mini_dash_direction.y = 0  # Mantiene la Y constante
	
	is_mini_dashing = true
	mini_dash_timer = MINI_DASH_DURATION
