extends Enemy

var bullet = preload("res://Scenes/Enemies/Misc/EnemyBullet.tscn")
var currentState
var isAttacking
var time_since_last_interaction: float = 0.0
var interaction_threshold: float = 3.0
var is_player_in_area: bool = false  # Nuevo: para saber si el jugador está dentro


func _ready() -> void:
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


func shoot_in_four_directions():
	var directions = [
		Vector3(0, 0, -1),  # Adelante
		Vector3(0, 0, 1),   # Atrás 
		Vector3(-1, 0, 0),  # Izquierda 
		Vector3(1, 0, 0)    # Derecha 
	]
	
	for direction in directions:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_transform.origin = self.global_transform.origin
		bullet_instance.direction = direction
		get_tree().root.add_child(bullet_instance)
