extends Enemy

var current_state = null
var is_state_active = false


const MAP_BOUNDS_MIN_X = -3.5
const MAP_BOUNDS_MAX_X = -3.5
const MAP_BOUNDS_MIN_Z = -6.5
const MAP_BOUNDS_MAX_Z = 6.5

func _ready() -> void:
	Global.enemies_remaining += 1
	await get_tree().create_timer(1).timeout
	var canStart = false
	while !canStart:
		await get_tree().create_timer(0.2).timeout
		if Global.dialog_ended == true:
			canStart = true
	enem_area_disabled()
	$AnimationPlayer.play("idle")
	select_state()

func select_state():
	if is_state_active:
		return
	
	is_state_active = true
	current_state = get_random_state()
	match current_state:
		State.IDLE:
			idle_state()
		State.WALK:
			walk_state()
		State.ATTACK:
			attack_state()

func walk_state():
	print("walk")
	$AnimationPlayer.play("idle")

	var target_pos = generate_valid_random_position()
	nav.target_position = target_pos

	var timer = get_tree().create_timer(4.0)
	var navigation_completed = false

	while timer.time_left > 0 and not nav.is_navigation_finished():
		await get_tree().create_timer(0.1).timeout 
	
	navigation_completed = nav.is_navigation_finished()
	is_state_active = false
	
	select_state()

func generate_valid_random_position() -> Vector3:
	var valid_position = false
	var target_pos = Vector3.ZERO
	var attempts = 0
	const MAX_ATTEMPTS = 5
	
	while not valid_position and attempts < MAX_ATTEMPTS:
		attempts += 1
		var posx = randf_range(MAP_BOUNDS_MIN_X, MAP_BOUNDS_MAX_X)
		var posz = randf_range(MAP_BOUNDS_MIN_Z, MAP_BOUNDS_MAX_Z)
		target_pos = global_transform.origin + Vector3(posx, 0, posz)
		
		if (target_pos.x >= MAP_BOUNDS_MIN_X and target_pos.x <= MAP_BOUNDS_MAX_X and
			target_pos.z >= MAP_BOUNDS_MIN_Z and target_pos.z <= MAP_BOUNDS_MAX_Z):
			valid_position = true
	
	if not valid_position:
		target_pos = global_transform.origin
	
	return target_pos

func idle_state():
	$AnimationPlayer.play("idle")
	await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
	is_state_active = false
	select_state()
	
func attack_state():
	print("attack")
	is_state_active = true
	velocity = Vector3.ZERO
	$AnimationPlayer.play("prepare")
	await get_tree().create_timer(1.5).timeout

	var target_pos = player.global_transform.origin

	if not nav.is_target_reachable():
		is_state_active = false
		select_state()
		return

	speed = 15
	$AnimationPlayer.play("attack")
	enem_area_enabled()
	nav.target_position = target_pos
	
	while not nav.is_navigation_finished():
		await get_tree().create_timer(0.1).timeout 
	
	speed = 3
	enem_area_disabled()
	is_state_active = false
	select_state()
