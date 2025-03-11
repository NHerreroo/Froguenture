extends CharacterBody3D

var pauseMenu = preload("res://Scenes/pause_menu.tscn")

var SPEED = Player.speed
var direction

const DASH_SPEED = 20.0  
const DASH_DURATION = 0.28  
var DASH_COOLDOWN = Player.dashCooldown

const LERP_AMOUNT = 0.4
const DASH_LERP_AMOUNT = 0.15
const MINI_DASH_SPEED = 5.0
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
var last_direction = Vector3(0.278882, 0, -0.960325)  # ultima direecion para los de mando si no testan haciendo el input

const MESH_DISTANCE = 1.5  # Distancia del MeshInstance al personaje
var can_atack = true
var attack_count = 0  # Contador de ataques en el combo
var attack_anim
# Temporizador para controlar el tiempo sin atacar
var attack_timer = 0.0
var speedAtack = Player.atackSpeed
var currentAtackAnimation = "Atack1_right" #def animation

@onready var atackMesh = $AtackMesh
@onready var attackCollider = $AtackMesh/Area3D/AttackCollider

var hud = null

func _ready():
	setPlayerPosition(Global.playerDirection)
	
func _process(delta: float) -> void:
	hud = get_tree().get_root().find_child("Hud", true, false)
	camera = get_tree().get_root().find_child("Camera", true, false) #esto lo pongo aqui por que al cambiar de nivel tmb cambia de camara
	# Incrementa el temporizador de ataque si no está atacando
	if can_atack:
		attack_timer += delta
		if attack_timer >= 0.15:
			SPEED = Player.speed


func setPlayerPosition(position: int):
	match position:
		0: self.position = Vector3(4.038, 0.014, -0.207)  # arriba
		1: self.position = Vector3(-3.962, 0.014, -0.207) # abajo
		2: self.position = Vector3(0.038, 0.014, -7.707)  # izquierda
		3: self.position = Vector3(0.038, 0.014, 7.793)   # derecha
		4: self.position = Vector3(2.638, 0.014, -0.207)  # mitad (inicio partida)

func _physics_process(delta):
	var input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO: 
		last_direction = direction
		
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

# Manejo de animaciones
func play_animation(anim_name: String):
	if anim_name == currentAtackAnimation:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name
		return
	if current_animation != anim_name and SPEED != 0:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name	

func update_attack_animation():
	# Posición del ratón en la pantalla
	var mouse_pos = get_viewport().get_mouse_position()
	# Ancho del viewport para dividirlo a la mitad
	var viewport_width = get_viewport().size.x
	var viewport_center = viewport_width / 2

	if Global.controller_active:
		if direction.z > 0:
			currentAtackAnimation = "Atack1_left"
		elif direction.z < 0:
			currentAtackAnimation = "Atack1_right"
		else:
			# Si la componente horizontal no es dominante, mantenemos la última dirección
			if currentAtackAnimation == "":
				currentAtackAnimation = "Atack1_right"  # Valor por defecto, o puedes usar el último estado
	else:
		# Si el controlador no está activo, usa la posición del ratón
		if mouse_pos.x < viewport_center:
			currentAtackAnimation = "Atack1_left"
		else:
			currentAtackAnimation = "Atack1_right"


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
	if Global.controller_active:
		# Calcula el ángulo de rotación
		var target_rotation = atan2(direction.x, direction.z)
		# Calcula la nueva posición del MeshInstance en relación con el personaje
		var mesh_offset = Vector3(sin(target_rotation), 0, cos(target_rotation)) * MESH_DISTANCE
		atackMesh.global_position = self.global_position + mesh_offset
		# Ajusta la rotación del MeshInstance para que mire hacia afuera o en la dirección deseada
		atackMesh.look_at(self.global_position, Vector3.UP)
	else:
		var hit_position = shoot_raycast()  
		
		var direction_to_hit = (hit_position - self.global_position).normalized()
		direction_to_hit.y = 0 
		
		var mesh_offset = direction_to_hit * 1.5
		atackMesh.global_position = self.global_position + mesh_offset
		atackMesh.look_at(self.global_position, Vector3.UP)

func attack():
	if Input.is_action_just_pressed("atack") and can_atack:
		attackCollider.disabled = false
		update_attack_animation()
		play_animation(currentAtackAnimation)
		$Sprites/AnimationPlayer.seek(0, false)
		
		SPEED = 0
		can_atack = false  # Desactiva el ataque temporalmente
		attack_count += 1  # Incrementa el contador de ataques en el combo
		attack_timer = 0  # Reinicia el temporizador de ataque

		
		if attack_count >= 3: #ataque pro (tercer ataque)
			perform_attack() 
			camera.big_shake_camera()
			await get_tree().create_timer(speedAtack + 0.4).timeout
			can_atack = true
			attack_count = 0
			attackCollider.disabled = true
			return
		else:
			perform_attack()
			camera.low_shake_camera()
			await get_tree().create_timer(speedAtack).timeout
			can_atack = true
			attackCollider.disabled = true
			return

func perform_attack():
	rotate_atack_mesh()  # Orienta el ataque en dirección del raycast
	if Global.controller_active:
		# Si no hay entrada de movimiento, usa la última dirección
		if direction == Vector3.ZERO:
			mini_dash_direction = last_direction
		else:
			mini_dash_direction = direction
	else:  # Si el teclado está activo
		var hit_position = shoot_raycast()
		mini_dash_direction = (hit_position - self.global_position).normalized()
		mini_dash_direction.y = 0  # Mantiene la Y constante

	is_mini_dashing = true
	mini_dash_timer = MINI_DASH_DURATION

# Mini-dash en ataque
func perform_mini_dash(delta):
	velocity.x = lerp(velocity.x, mini_dash_direction.x * MINI_DASH_SPEED, LERP_AMOUNT)
	velocity.z = lerp(velocity.z, mini_dash_direction.z * MINI_DASH_SPEED, LERP_AMOUNT)	
	
	mini_dash_timer -= delta
	if mini_dash_timer <= 0:
		is_mini_dashing = false

#hacerdaño
var canReciveDamage = true
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("enemy"):
		if canReciveDamage == true: 
			if camera:
				camera.frameFreeze(0.05, 1.0)
				camera.low_shake_camera()
		take_damage(Player.damageToRecive)
	

func take_damage(amount: float) -> void:
	canReciveDamage = false

	# Primero reduce los corazones azules
	if Player.shield > 0:
		Player.shield -= amount
		if Player.shield < 0:
			Player.health += Player.shield  # Si sobra daño, lo pasa a los corazones rojos
			Player.shield = 0
	else:
		Player.health -= amount

	# Limita la salud mínima
	if Player.health < 0:
		Player.health = 0
	
	if hud:
		hud.update_hearts()
	await get_tree().create_timer(Player.invencibleTime).timeout
	canReciveDamage = true


func heal(amount: float) -> void:
	# Cura solo corazones rojos y respeta el límite de contenedores
	Player.health += amount
	if Player.health > Player.health_container:
		Player.health = Player.health_container

func add_shield(amount: float) -> void:
	# Añade corazones azules
	Player.shield += amount
