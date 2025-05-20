extends CharacterBody3D

var pauseMenu = preload("res://Scenes/pause_menu.tscn")
var ghost = preload("res://Scenes/Ghost.tscn")
var poison = preload("res://Scenes/DashPoison.tscn")

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

var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector3.ZERO
var ghost_spawn_timer = 0.0
const GHOST_SPAWN_INTERVAL = 0.05

var is_mini_dashing = false
var mini_dash_timer = 0.0
var mini_dash_direction = Vector3.ZERO
var last_direction = Vector3(0.278882, 0, -0.960325)

const MESH_DISTANCE = 1.5
var can_atack = true
var attack_count = 0
var attack_anim
var attack_timer = 0.0
var speedAtack = Player.atackSpeed
var currentAtackAnimation = "Atack1_right"

@onready var atackMesh = $AtackMesh
@onready var attackCollider = $AtackMesh/Area3D/AttackCollider

var hud = null

func _ready():
	$OmniLight3D/AnimationPlayer.play("Light")
	$CanvasLayer/ColorRect.visible = false
	setPlayerPosition(Global.playerDirection)
	
func _process(delta: float) -> void:
	hud = get_tree().get_root().find_child("Hud", true, false)
	camera = get_tree().get_root().find_child("Camera", true, false)
	
	if can_atack:
		attack_timer += delta
		if attack_timer >= 0.2:
			attack_count = 0
			SPEED = Player.speed   

func setPlayerPosition(position: int):
	match position:
		0: self.position = Vector3(4.038, 0.014, -0.207)
		1: self.position = Vector3(-3.962, 0.014, -0.207)
		2: self.position = Vector3(0.038, 0.014, -7.707)
		3: self.position = Vector3(0.038, 0.014, 7.793)
		4: self.position = Vector3(2.638, 0.014, -0.207)

func _physics_process(delta):
	if !Global.can_walk:
		$Sprites/AnimationPlayer.play("idle")

	var input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction != Vector3.ZERO: 
		last_direction = direction
		
	perform_dash(delta, direction)
	
	if is_mini_dashing:
		perform_mini_dash(delta)
	else:
		if not Player.is_dashing:
			velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_AMOUNT)
			velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_AMOUNT)

	if Global.can_walk:
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

func perform_dash(delta, direction):
	if Player.is_dashing:
		velocity.x = lerp(velocity.x, dash_direction.x * DASH_SPEED, DASH_LERP_AMOUNT)
		velocity.z = lerp(velocity.z, dash_direction.z * DASH_SPEED, DASH_LERP_AMOUNT)

		ghost_spawn_timer += delta
		if ghost_spawn_timer >= GHOST_SPAWN_INTERVAL:
			ghost_spawn_timer = 0
			spawnGhost()
			if Player.havePosionDash:
				spawnPoison()
		
		dash_timer -= delta
		if dash_timer <= 0:
			Player.is_dashing = false
			velocity = Vector3.ZERO
	elif dash_cooldown_timer <= 0 and Input.is_action_just_pressed("dash"):
		Player.is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		dash_direction = direction if direction != Vector3.ZERO else last_direction
		ghost_spawn_timer = 0
		spawnGhost()
		if Player.havePosionDash:
			spawnPoison()

	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func play_animation(anim_name: String):
	if anim_name == currentAtackAnimation:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name
		return
	if current_animation != anim_name and SPEED != 0:
		$Sprites/AnimationPlayer.play(anim_name)
		current_animation = anim_name	

func update_attack_animation():
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_width = get_viewport().size.x
	var viewport_center = viewport_width / 2

	if Global.controller_active:
		if direction.z > 0:
			currentAtackAnimation = "Atack%d_left" % (attack_count + 1)
		elif direction.z < 0:
			currentAtackAnimation = "Atack%d_right" % (attack_count + 1)
	else:
		if mouse_pos.x < viewport_center:
			currentAtackAnimation = "Atack%d_left" % (attack_count + 1)
		else:
			currentAtackAnimation = "Atack%d_right" % (attack_count + 1)

func shoot_raycast() -> Vector3:
	if not camera:
		return self.global_position
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
		var target_rotation = atan2(direction.x, direction.z)
		var mesh_offset = Vector3(sin(target_rotation), 0, cos(target_rotation)) * MESH_DISTANCE
		atackMesh.global_position = self.global_position + mesh_offset
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
		hitSound()
		attackCollider.disabled = false
		update_attack_animation()
		play_animation(currentAtackAnimation)
		$Sprites/AnimationPlayer.seek(0, false)
		
		SPEED = 0
		can_atack = false  
		attack_timer = 0  

		if attack_count >= 2:
			perform_attack() 
			if camera:
				camera.big_shake_camera()
			await get_tree().create_timer(speedAtack + 0.4).timeout
			can_atack = true
			attack_count = 0
			attackCollider.disabled = true
		else:
			perform_attack()
			if camera:
				camera.low_shake_camera()
			await get_tree().create_timer(speedAtack).timeout
			can_atack = true
			attackCollider.disabled = true

func perform_attack():
	if attack_count < 2:
		attack_count += 1
	else:
		attack_count = 0
	rotate_atack_mesh()
	if Global.controller_active:
		mini_dash_direction = direction if direction != Vector3.ZERO else last_direction
	else:
		var hit_position = shoot_raycast()
		mini_dash_direction = (hit_position - self.global_position).normalized()
		mini_dash_direction.y = 0

	is_mini_dashing = true
	mini_dash_timer = MINI_DASH_DURATION

func perform_mini_dash(delta):
	velocity.x = lerp(velocity.x, mini_dash_direction.x * MINI_DASH_SPEED, LERP_AMOUNT)
	velocity.z = lerp(velocity.z, mini_dash_direction.z * MINI_DASH_SPEED, LERP_AMOUNT)	
	
	mini_dash_timer -= delta
	if mini_dash_timer <= 0:
		is_mini_dashing = false

var canReciveDamage = true
func _on_area_3d_area_entered(area: Area3D) -> void:
	if Player.is_dashing:
		return
	if area.is_in_group("enemy") and canReciveDamage:
		canReciveDamage = false
		take_damage(Player.damageToRecive)
		if camera:
			camera.frameFreeze(0.05, 1.0)
			camera.low_shake_camera()
		await get_tree().create_timer(Player.invencibleTime).timeout
		canReciveDamage = true


func take_damage(amount: float) -> void:
	$CanvasLayer/ColorRect/AnimationPlayer.play("new_animation")
	if Player.shield > 0:
		Player.shield -= amount
		if Player.shield < 0:
			Player.health += Player.shield 
			Player.shield = 0
	else:
		Player.health -= amount

	if Player.health < 0:
		Player.health = 0
	
	if hud:
		hud.update_hearts()
	
	await get_tree().create_timer(Player.invencibleTime).timeout
	canReciveDamage = true

func heal(amount: float) -> void:
	Player.health += amount
	if Player.health > Player.health_container:
		Player.health = Player.health_container

func add_shield(amount: float) -> void:
	Player.shield += amount

var hit1 = preload("res://Sounds/SFX/WHSH_Whoosh_HoveAud_SwordCombat_07.wav")
var hit2 = preload("res://Sounds/SFX/WHSH_Whoosh_HoveAud_SwordCombat_26.wav")

func hitSound():
	$AudioStreamPlayer.stream = hit2 if attack_count >= 2 else hit1
	$AudioStreamPlayer.volume_db = -30  
	$AudioStreamPlayer.play()

func spawnGhost():
	var newGhost = ghost.instantiate()
	newGhost.position = self.position
	newGhost.rotation = self.rotation
	get_parent().add_child(newGhost)


func spawnPoison():
	var newPoison = poison.instantiate()
	newPoison.position = Vector3(self.position.x,0.7,self.position.z)
	get_parent().add_child(newPoison)
