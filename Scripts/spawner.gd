extends Node3D

var slime = preload("res://Scenes/Enemies/Slime_Purple.tscn")
var rock = preload("res://Scenes/Enemies/RockBoy.tscn")
var mole = preload("res://Scenes/Enemies/Mole.tscn")
var fishy = preload("res://Scenes/Enemies/FishyBoy.tscn")

func _ready() -> void:
	var habitacion_id = str(Global.map[Global.playerMapPositionX][Global.playerMapPositionY])
	
	if SpawnPoints.spawn_points.has(habitacion_id):
		var patrones = SpawnPoints.spawn_points[habitacion_id]
		var keys = patrones.keys()
		
		# Elegimos un patrón aleatorio
		var patron_random = keys[randi() % keys.size()]
		var posiciones = patrones[patron_random]
		
		for posicion in posiciones:
			spawn_random_enemy(posicion)
	else:
		print("No hay patrones definidos para la habitación:", habitacion_id)

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
