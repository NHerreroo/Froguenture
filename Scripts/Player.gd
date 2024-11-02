extends CharacterBody3D

var pauseMenu = preload("res://Scenes/pause_menu.tscn")

const SPEED = 5.0
const DASH_SPEED = 20.0  
const DASH_DURATION = 0.28  
const DASH_COOLDOWN = 1.0 
const MINI_DASH_SPEED = 10.0
const MINI_DASH_DURATION = 0.1

const LERP_AMOUNT = 0.4
const DASH_LERP_AMOUNT = 0.15

var current_animation = ""
var camera  # Variable para la cámara

# Variables para el dash
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector3.ZERO

var is_mini_dashing = false
var mini_dash_timer = 0.0

@onready var atackMesh = $AtackMesh

func _ready():
	setPlayerPosition(Global.playerDirection)
	
	camera = get_tree().get_root().find_child("Camera", true, false)

func setPlayerPosition(position: int):
	match position:
		0: #arriba
			self.position = Vector3(4.038, 0.014, -0.207) 
		1: #abajo
			self.position = Vector3(-3.962, 0.014, -0.207)
		2: #izquierda
			self.position = Vector3(0.038, 0.014, -7.707)
		3: #derecha
			self.position = Vector3(0.038, 0.014, 7.793)
		4: #mitad (solo inicio partida)
			self.position = Vector3(2.638, 0.014, -0.207)

func _physics_process(delta):
	var input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	perform_dash(delta, direction)
	
	if not is_dashing:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_AMOUNT)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_AMOUNT)
	
	if Global.can_walk:
		
		if Input.is_action_just_pressed("atack"):
			rotate_mesh_instance_around_player()
		
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

		move_and_slide()

# Manejar el dash principal
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


# Manejo de animaciones
func play_animation(anim_name: String):
	if current_animation != anim_name:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name



#----------------Funciones de ataque ------------------

func shoot_raycast() -> Vector3: #dispara el raycast para poder direccionar el ataqe (no se ni si va a salir)
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_lenght = 1000
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_lenght
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	if raycast_result:  # El if es para prevenir q no salga el raycast fuera del mapa y pete (Por experiencia XDD)
		print("Raycast hit at: ", raycast_result.position)
		return raycast_result.position 
	else:
		return self.global_position  

func rotate_mesh_instance_around_player():
	var hit_position = shoot_raycast()  
	
	var direction_to_hit = (hit_position - self.global_position).normalized()
	direction_to_hit.y = 0 
	
	var mesh_offset = direction_to_hit * 1.5
	atackMesh.global_position = self.global_position + mesh_offset
	
	atackMesh.look_at(self.global_position, Vector3.UP)
