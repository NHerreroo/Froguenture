extends CharacterBody3D
class_name Enemy

var dropitem = preload("res://Scenes/Dropps/Coin.tscn")

@export var enemy_src : enemy_source

@onready var area: Area3D = $MeshInstance3D/Area3D  # Referencia al Area3D dentro del CharacterBody3D
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var player
@onready var speed = enemy_src.speed
@onready var accel = enemy_src.accel
@onready var knockback_velocity = Vector3.ZERO
@onready var knockback_duration = enemy_src.knockback_duration
@onready var knockback_timer = enemy_src.knockback_timer

@onready var health = enemy_src.health
@onready var maxHealth = enemy_src.health

var random_index
var state_available = true

enum state {
	IDLE,
	MOVING,
	ATTACKING
}

	
func _physics_process(delta: float) -> void:
	var player_pos_array = [Global.playerMapPositionX, Global.playerMapPositionY]
	if player_pos_array in Global.rooms_visited:
		Global.enemies_remaining = 0
		queue_free()
	if Global.eraseLevel:
		Global.enemies_remaining -= 1
		queue_free()
	match random_index:
		0:
			walk_state(delta)
		1:
			walk_state(delta)
		2:
			walk_state(delta)
	

func get_random_state():
	# Genera un número aleatorio entre 0 y la cantidad de estados - 1
	random_index = randi_range(0, int(state.size()) - 1)
	return state.values()[random_index]

func idle_state():
	pass

func walk_state(delta: float):
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




		
#REACCION AL ATAQUE
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("attack"):
		var knockback_direction = (global_transform.origin - area.global_transform.origin).normalized()
		knockback_velocity = knockback_direction * 10.0 
		knockback_timer = knockback_duration

		# Restar salud por el ataque
		var damage = 15
		health -= damage

		# Asegurarse de que la salud no sea negativa
		if health < 0:
			health = 0

		var health_ratio = float(health) / float(maxHealth)
		
		# Ajustar la escala de la barra de progreso proporcionalmente
		$ProgressBar.scale.x = health_ratio
		
		# Eliminar el enemigo si la salud llega a 0
		if health <= 0:
			Global.enemies_remaining -= 1
			dropitemfunc()
			queue_free()

func dropitemfunc():
	var item = dropitem.instantiate()
	item.position = Vector3(self.position.x, self.position.y + 0.5, self.position.z)
	var parent_node = get_parent()

	# Agrega el objeto dropeado al nodo padre
	if parent_node:
		parent_node.add_child(item)
	else:
		print("no hay padre")
