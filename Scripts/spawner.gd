extends Node3D

var slime = preload("res://Scenes/Enemies/Slime_Purple.tscn")
var rock = preload("res://Scenes/Enemies/RockBoy.tscn")
var mole = preload("res://Scenes/Enemies/Mole.tscn")
var fishy = preload("res://Scenes/Enemies/FishyBoy.tscn")

var current_pos
func _ready() -> void:
	current_pos = [Global.playerMapPositionX, Global.playerMapPositionY]
	if current_pos in Global.rooms_visited:
		Global.enemies_remaining = 0
		queue_free()

	var habitacion_id = str(Global.map[Global.playerMapPositionX][Global.playerMapPositionY])
		
	if SpawnPoints.spawn_points.has(habitacion_id):
		var patrones = SpawnPoints.spawn_points[habitacion_id]
		var keys = patrones.keys()
			
			# Elegimos un patrón aleatorio
		var patron_random = keys[randi() % keys.size()]
		var posiciones = patrones[patron_random]
			
		for posicion in posiciones:
			spawn_random_enemy(posicion)

func spawn_random_enemy(posicion: Vector3):
	var rand_enem = randi_range(1, 4)
	var enemy
	
	match rand_enem:
		1:
			enemy = slime.instantiate()
		2:
			enemy = rock.instantiate()
		3:
			enemy = mole.instantiate()
		4:
			enemy = fishy.instantiate()
		_:
			enemy = slime.instantiate()
	
	enemy.position = posicion
	get_tree().root.add_child(enemy)
