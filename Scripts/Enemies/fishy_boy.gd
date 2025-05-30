extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var currentState
var follow = false
var obstacle_avoidance_timer = 0.0
var obstacle_avoidance_direction = Vector3.ZERO

func _ready() -> void:
	var current_pos = [Global.playerMapPositionX, Global.playerMapPositionY]
	if current_pos in Global.rooms_visited:
		Global.enemies_remaining = 0
		queue_free()
	Global.enemies_remaining += 1
	await get_tree().create_timer(1).timeout
	follow = true
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:
	if follow == true:
		super._physics_process(delta)
		
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(
			global_transform.origin,
			player.global_transform.origin,
			collision_mask
		)
		var result = space_state.intersect_ray(query)
		
		if result:
			obstacle_avoidance_timer = 1.0 
			
			var to_player = (player.global_transform.origin - global_transform.origin).normalized()
			var obstacle_normal = result.normal
			obstacle_avoidance_direction = to_player.slide(obstacle_normal).normalized()
			
			obstacle_avoidance_direction = obstacle_avoidance_direction.rotated(
				Vector3.UP, randf_range(-PI/4, PI/4))
			
		if obstacle_avoidance_timer > 0:
			nav.target_position = global_transform.origin + obstacle_avoidance_direction * 2.0
			obstacle_avoidance_timer -= delta
		else:
			nav.target_position = player.global_transform.origin
