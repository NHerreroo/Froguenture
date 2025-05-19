extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var currentState
var isAttacking
var time_since_last_interaction: float = 0.0
var interaction_threshold: float = 3.0
var is_player_in_area: bool = false  # Nuevo: para saber si el jugador está dentro


func _ready() -> void:
	enem_area_disabled()
	Global.enemies_remaining += 1
	protect()  # Iniciar en estado de protección


func attack():
	$AnimationPlayer.play("attack")
	canReciveDamage = true
	await get_tree().create_timer(2.5).timeout
	isAttacking = false
	protect()


func protect():
	$AnimationPlayer.play("protected")
	canReciveDamage = false


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if not is_player_in_area and not isAttacking:
		time_since_last_interaction += delta
	
		if time_since_last_interaction >= interaction_threshold:
			time_since_last_interaction = 0.0
			isAttacking = true
			attack()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_in_area = true  
		time_since_last_interaction = 0.0  
		if isAttacking == false:
			protect()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_player_in_area = false  
		time_since_last_interaction = 0.0 
		isAttacking = true
		attack()


func shoot_fan_towards_player():
	var player = get_tree().get_root().find_child("player", true, false)  # Cambia esto según tu escena
	if player == null:
		return

	var direction_to_player = (player.global_transform.origin - global_transform.origin).normalized()

	# Configuración del abanico
	var num_bullets = 3
	var spread_angle_deg = 40 

	for i in range(num_bullets):
		var t = float(i) / float(num_bullets - 1) 
		var angle_offset_deg = (t - 0.5) * spread_angle_deg 
		var rotated_direction = direction_to_player.rotated(Vector3.UP, deg_to_rad(angle_offset_deg))

		var bullet_instance = bullet.instantiate()
		bullet_instance.global_transform.origin = global_transform.origin
		bullet_instance.scale = Vector3(0.6, 0.6, 0.6)
		bullet_instance.direction = rotated_direction
		get_tree().root.add_child(bullet_instance)
