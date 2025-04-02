extends CharacterBody3D
class_name Enemy

var coin = preload("res://Scenes/Dropps/Coin.tscn")
var shield = preload("res://Scenes/Dropps/Shield.tscn")
var heart = preload("res://Scenes/Dropps/Heart.tscn")

var dust = preload("res://Scenes/Enemies/dust.tscn")

@export var enemy_src : enemy_source

@onready var area: Area3D = $MeshInstance3D/Area3D  
@onready var nav: NavigationAgent3D = $NavigationAgent3D

var player
@onready var speed = enemy_src.speed
@onready var accel = enemy_src.accel
@onready var knockback_velocity = Vector3.ZERO
@onready var knockback_duration = enemy_src.knockback_duration
@onready var knockback_timer = enemy_src.knockback_timer

@onready var health = enemy_src.health
@onready var maxHealth = enemy_src.health

func _physics_process(delta: float) -> void:
	var player_pos_array = [Global.playerMapPositionX, Global.playerMapPositionY]
	if player_pos_array in Global.rooms_visited:
		Global.enemies_remaining = 0
		queue_free()
	if Global.eraseLevel:
		Global.enemies_remaining -= 1
		queue_free()

	player = get_tree().get_root().find_child("player", true, false)

	if knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
	else:
		knockback_velocity = Vector3.ZERO
		var direction = (nav.get_next_path_position() - global_transform.origin).normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)

	move_and_slide()
	
	var current_position = global_transform.origin
	current_position.y = 0
	global_transform.origin = current_position

# REACCIÓN AL ATAQUE
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("attack"):
		var knockback_direction = (global_transform.origin - area.global_transform.origin).normalized()
		knockback_velocity = knockback_direction * 10.0  
		knockback_timer = knockback_duration

		# Restar salud por el ataque
		var damage = 15
		health -= damage
		health = max(0, health) 

		if health <= 0:
			Global.enemies_remaining -= 1
			dropitemfunc()
			spawn_dust()
			queue_free()

func dropitemfunc():
	var items = [coin, shield, heart]
	var random_index = randi() % items.size()
	var selected_item = items[random_index]
	var item = selected_item.instantiate()
	item.position = Vector3(self.position.x, self.position.y + 0.3, self.position.z)

	var parent_node = get_parent()
	if parent_node:
		parent_node.add_child(item)
		
func spawn_dust():
	var dust_inst = dust.instantiate()
	dust_inst.position = Vector3(self.position.x, 0 ,self.position.z)
	get_tree().root.add_child(dust_inst)
