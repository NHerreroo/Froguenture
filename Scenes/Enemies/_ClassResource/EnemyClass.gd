extends CharacterBody3D
class_name Enemy

@export var enemy_src : enemy_source

@onready var area: Area3D = $MeshInstance3D/Area3D  # Referencia al Area3D dentro del CharacterBody3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var player
@onready var speed = enemy_src.speed
@onready var accel = enemy_src.accel
@onready var knockback_velocity = Vector3.ZERO
@onready var knockback_duration = enemy_src.knockback_duration
@onready var knockback_timer = enemy_src.knockback_timer

@onready var healt = enemy_src.health

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
