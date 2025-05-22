extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var use_diagonal = false  # Alternador de disparo

func _ready() -> void:
	enem_area_disabled()
	Global.enemies_remaining += 1
	$AnimationPlayer.play("RESET")
	await get_tree().create_timer(1).timeout
	logic()

func logic():
	while true:
		await entry()
		await get_tree().create_timer(2).timeout
		attack()
		await get_tree().create_timer(4).timeout
		exit()
		await get_tree().create_timer(2).timeout

func entry():
	$MeshInstance3D/Area3D/CollisionShape3D.disabled = true
	$AnimationPlayer.play("entry")

	var valid_position_found = false
	var attempts = 0
	var max_attempts = 30
	
	while not valid_position_found and attempts < max_attempts:
		attempts += 1
		
		var random_pos = Vector3(
			randf_range(-7.5, 7.5),
			0,
			randf_range(-3.5, 3.5)
		)
		print(random_pos)
		
		nav.target_position = random_pos
		await get_tree().process_frame 
		
		if nav.is_navigation_finished():
			global_position = nav.get_final_position()
			valid_position_found = true
		else:
			var suggested_pos = nav.get_next_path_position()
			if suggested_pos.distance_to(random_pos) < 2.0: 
				global_position = suggested_pos
				valid_position_found = true
	
	if not valid_position_found:
		global_position = Vector3.ZERO

func attack():
	$MeshInstance3D/Area3D/CollisionShape3D.disabled = false
	$AnimationPlayer.play("idle")
	await get_tree().create_timer(2).timeout
	
	shoot_bullets()
	
	use_diagonal = !use_diagonal

func exit():
	$MeshInstance3D/Area3D/CollisionShape3D.disabled = true
	$AnimationPlayer.play("exit")
	await $AnimationPlayer.animation_finished

func shoot_bullets():
	var directions = []

	if use_diagonal:
		# Forma X 
		directions = [
			Vector3(1, 0, 1).normalized(),
			Vector3(1, 0, -1).normalized(),
			Vector3(-1, 0, 1).normalized(),  
			Vector3(-1, 0, -1).normalized() 
		]
	else:
		# Forma +
		directions = [
			Vector3(0, 0, -1),
			Vector3(0, 0, 1),
			Vector3(-1, 0, 0),
			Vector3(1, 0, 0)
		]

	for direction in directions:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_transform.origin = global_position
		bullet_instance.scale = Vector3(0.6, 0.6, 0.6)
		bullet_instance.direction = direction
		get_parent().add_child(bullet_instance)
