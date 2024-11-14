extends CharacterBody3D

@onready var area: Area3D = $MeshInstance3D/Area3D  # Referencia al Area3D dentro del CharacterBody3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var player
var speed = 3.0
var accel = 10.0
var knockback_velocity = Vector3.ZERO 
var knockback_duration = 0.2 
var knockback_timer = 0.0  

var healt = 50

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("attack"):
		var knockback_direction = (global_transform.origin - area.global_transform.origin).normalized()
		knockback_velocity = knockback_direction * 10.0 
		knockback_timer = knockback_duration
		
		healt -= 25
		if healt <= 0:
			queue_free()

func _physics_process(delta: float):
	player = get_tree().get_root().find_child("player", true, false)

	if knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
	else:
		knockback_velocity = Vector3.ZERO
		
		if player:
			nav.target_position = player.global_transform.origin
			
			var direction = nav.get_next_path_position() - global_transform.origin
			direction = direction.normalized()
			
			velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
	
	var current_position = global_transform.origin
	current_position.y = 0
	global_transform.origin = current_position
