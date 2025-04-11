extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	Global.enemies_remaining += 1
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
	
	var nav_region = get_parent().find_child("NavigationRegion3D")
	if not nav_region:
		return
	
	var nav_map = nav_region.get_navigation_map()
	
	var nav_mesh = nav_region.navigation_mesh
	if not nav_mesh:
		return
	
	var vertices = nav_mesh.get_vertices()
	if vertices.size() == 0:
		return
	
	# Calcular límites manualmente
	var min_pos = vertices[0]
	var max_pos = vertices[0]
	for v in vertices:
		min_pos = min_pos.min(v)
		max_pos = max_pos.max(v)
	
	var attempts = 20 
	var found_position = false
	
	for i in range(attempts):
		var random_pos = Vector3(
			randf_range(min_pos.x, max_pos.x),
			0,
			randf_range(min_pos.z, max_pos.z)
		)

		var closest_point = NavigationServer3D.map_get_closest_point(nav_map, random_pos)
		
		if closest_point.distance_to(random_pos) < 2.0:
			global_position = closest_point
			found_position = true
			break
	
	if not found_position:
		global_position = Vector3.ZERO
	
	$AnimationPlayer.play("entry")

func attack():
	$MeshInstance3D/Area3D/CollisionShape3D.disabled = false
	$AnimationPlayer.play("idle")
	await get_tree().create_timer(2).timeout
	shoot_in_four_directions()

func exit():
	$MeshInstance3D/Area3D/CollisionShape3D.disabled = true
	$AnimationPlayer.play("exit")
	await $AnimationPlayer.animation_finished

func shoot_in_four_directions():
	var directions = [
		Vector3(0, 0, -1),  # Adelante
		Vector3(0, 0, 1),   # Atrás 
		Vector3(-1, 0, 0),  # Izquierda 
		Vector3(1, 0, 0)    # Derecha 
	]
	
	for direction in directions:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_transform.origin = global_position
		bullet_instance.scale = Vector3(0.6, 0.6, 0.6)
		bullet_instance.direction = direction
		get_parent().add_child(bullet_instance)  # Añadir al nivel en lugar de a root
