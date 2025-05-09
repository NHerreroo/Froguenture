extends CharacterBody3D
class_name Enemy

var coin = preload("res://Scenes/Dropps/Coin.tscn")
var shield = preload("res://Scenes/Dropps/Shield.tscn")
var heart = preload("res://Scenes/Dropps/Heart.tscn")

var dust = preload("res://Scenes/Enemies/dust.tscn")

var canReciveDamage = true

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

enum State {
	IDLE,
	WALK,
	ATTACK
	}
	
	
func _physics_process(delta: float) -> void:
	if Global.dialog_ended == false:
		return
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


func get_random_state() -> State:
	var states = [State.IDLE, State.WALK, State.ATTACK]
	return states[randi() % states.size()]

# REACCIÓN AL ATAQUE
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("attack") and canReciveDamage:
		var knockback_direction = (global_transform.origin - area.global_transform.origin).normalized()
		knockback_velocity = knockback_direction * 10.0  
		knockback_timer = knockback_duration
		flash_sprite3d()
		hitSound()

		# Restar salud por el ataque
		var damage = Player.atack
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

func enem_area_enabled():
	$MeshInstance3D/Area3D.add_to_group("enemy")

func enem_area_disabled():
	$MeshInstance3D/Area3D.remove_from_group("enemy")


const FLASH_SHADER : Shader = preload("res://Shaders/flash_sahder.gdshader")
func flash_sprite3d() -> void:
	var flash_shader = load("res://Shaders/flash_sahder.gdshader")
	
	var affected_nodes = []
	
	find_and_apply_flash(self, flash_shader, affected_nodes)
	
	await get_tree().create_timer(0.2).timeout
	
	for node_data in affected_nodes:
		var node = node_data[0]
		var original_material = node_data[1]
		if is_instance_valid(node):
			node.material_override = original_material

func find_and_apply_flash(node: Node, shader: Shader, affected_nodes: Array) -> void:
	for child in node.get_children():
		if child is Sprite3D or child is AnimatedSprite3D:
			var original_material = child.material_override
			var new_material = ShaderMaterial.new()
			new_material.shader = shader
			
			if child is Sprite3D and child.texture:
				new_material.set_shader_parameter("albedo_texture", child.texture)
			elif child is AnimatedSprite3D and child.sprite_frames:
				var current_animation = child.animation
				var current_frame = child.frame
				var texture = child.sprite_frames.get_frame_texture(current_animation, current_frame)
				if texture:
					new_material.set_shader_parameter("albedo_texture", texture)
				else:
					continue
			else:
				continue
				
			new_material.set_shader_parameter("flash_color", Color(1,1,1,1))
			new_material.set_shader_parameter("flash_value", 1.0)
			
			child.material_override = new_material
			
			affected_nodes.append([child, original_material])
		
		find_and_apply_flash(child, shader, affected_nodes)


var hit1 = preload("res://Sounds/SFX/PUNCH_DESIGNED_HEAVY_86.wav")
var hit2 = preload("res://Sounds/SFX/PUNCH_PERCUSSIVE_HEAVY_09.wav")  
var hit3 = preload("res://Sounds/SFX/PUNCH_SQUELCH_HEAVY_01.wav")

func hitSound():
	var sounds = [hit1, hit2, hit3]
	$AudioStreamPlayer.stream = sounds[randi() % sounds.size()]
	$AudioStreamPlayer.volume_db = -40  # Baja el volumen a -10 dB (ajusta este valor)
	$AudioStreamPlayer.play()
