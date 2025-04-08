extends Node

# cargo las escenas de las puertas para poder hacer la instancia
var topDoor = preload("res://Scenes/Doors/TopDoor.tscn")
var bottomDoor = preload("res://Scenes/Doors/BottomDoor.tscn")
var leftDoor = preload("res://Scenes/Doors/LeftDoor.tscn")
var rightDoor = preload("res://Scenes/Doors/RightDoor.tscn")

# cargo las escenas de todas las habitaciones para poder instanciarlas dependiendo la posicion del array
var initRoom = preload("res://Scenes/Rooms/InitalRooms/initialRoom.tscn")
var room1 = preload("res://Scenes/Rooms/PreBuildedRooms/room1.tscn")
var room2 = preload("res://Scenes/Rooms/PreBuildedRooms/room2.tscn")
var room3 = preload("res://Scenes/Rooms/PreBuildedRooms/room3.tscn")
var room4 = preload("res://Scenes/Rooms/PreBuildedRooms/room4.tscn")

var finalRoom = preload("res://Scenes/Rooms/FinalRooms/FinalRoom.tscn")
var treasureRoom = preload("res://Scenes/Rooms/TreasureRooms/TreasureRoom.tscn")

var tavern1 = preload("res://Scenes/Rooms/Taverns/Tavern1.tscn")

# Constates Char para las salas
var ROOM = ''
const SHOP = '$'
const BOSS = 'X'
const TREASURE = '#'
const FIRST_ROOM = '@'
const EMPTY = ' '
var map

# Referencias a instancias activas
var activeDoors = []  # lista para las puertas actuales
var currentRoom = null  # referencia a la habitación actual

func defaultRoomGen():
	var randRoom = randi_range(1, 4)
	ROOM = str(randRoom)

func map_generator(map_size: int, steps: int) -> void:
	
	set_global_stats()
		
	Global.map = []  # Crear la matriz del mapa

	# Creo la matriz con espacios vacíos
	for i in range(map_size):
		Global.map.append([])  # Crear una nueva fila
		for j in range(map_size):
			Global.map[i].append(EMPTY)  # Llenar la fila con espacios vacíos

	var walker_pos_x = map_size / 2  # Posición inicial del walker en el centro
	var walker_pos_y = map_size / 2

	var shop_room = randi_range(1, steps - 2)
	var treasure_room = randi_range(1, steps - 2)

	# El centro de la matriz se marca con el @ para la sala inicial
	Global.map[walker_pos_x][walker_pos_y] = FIRST_ROOM

	var step_count = 1

	while step_count < steps:
		var direction = randi() % 4
		var new_pos_x = walker_pos_x
		var new_pos_y = walker_pos_y

		match direction:
			0:
				if walker_pos_x > 0:
					new_pos_x -= 1  # Izquierda
			1:
				if walker_pos_x < map_size - 1:
					new_pos_x += 1  # Derecha
			2:
				if walker_pos_y > 0:
					new_pos_y -= 1  # Arriba
			3:
				if walker_pos_y < map_size - 1:
					new_pos_y += 1  # Abajo
		if Global.map[new_pos_x][new_pos_y] == EMPTY:
			walker_pos_x = new_pos_x
			walker_pos_y = new_pos_y

			if step_count == steps - 1:
				Global.map[walker_pos_x][walker_pos_y] = BOSS
			elif step_count == shop_room:
				Global.map[walker_pos_x][walker_pos_y] = SHOP
			elif step_count == treasure_room:
				Global.map[walker_pos_x][walker_pos_y] = TREASURE
			else:
				defaultRoomGen()
				Global.map[walker_pos_x][walker_pos_y] = ROOM
				
			step_count += 1
	print_map(Global.map)
	Global.isMapGenerated = true

# Print de la matriz
func print_map(map: Array) -> void:
	for row in Global.map:
		print("".join(row))

func print_actual_pos(map: Array, x: int, y: int):
	print("actual position = " + Global.map[x][y])
# Generar puertas según la posición
func generate_doors(map: Array):
	set_all_colliders()
	clean_previous_doors()  # Limpiamos las puertas anteriores

	var x = Global.playerMapPositionX
	var y = Global.playerMapPositionY
	Global.map[x][y]

	if Global.map[x + 1][y] != ' ':
		var bottomDoorInst = bottomDoor.instantiate()
		bottomDoorInst.position = Vector3(5, 0, 0)
		add_child(bottomDoorInst)
		activeDoors.append(bottomDoorInst)
	else:
		Global.botCollider = true

	if Global.map[x - 1][y] != ' ':
		var topDoorInst = topDoor.instantiate()
		topDoorInst.position = Vector3(-5, 0, 0)
		add_child(topDoorInst)
		activeDoors.append(topDoorInst)
	else:
		Global.topCollider = true

	if Global.map[x][y + 1] != ' ':
		var rightDoorInst = rightDoor.instantiate()
		rightDoorInst.position = Vector3(0, 0, -8)
		add_child(rightDoorInst)
		activeDoors.append(rightDoorInst)
	else:
		Global.rightCollider = true

	if Global.map[x][y - 1] != ' ':
		var leftDoorInst = leftDoor.instantiate()
		leftDoorInst.position = Vector3(0, 0, 8)
		add_child(leftDoorInst)
		activeDoors.append(leftDoorInst)
	else:
		Global.leftCollider = true

# Instanciar la habitación
func instanceRoom():
	if currentRoom:
		currentRoom.queue_free()  # Liberar la habitación anterior
		
	var x = Global.playerMapPositionX
	var y = Global.playerMapPositionY

	if Global.map[x][y] == '@':
		currentRoom = initRoom.instantiate()
	elif Global.map[x][y] == 'X':
		currentRoom = finalRoom.instantiate()
	elif Global.map[x][y] == '$':
		currentRoom = tavern1.instantiate()
	elif Global.map[x][y] == '#':
		currentRoom = treasureRoom.instantiate() #ESTO ES PROVISIONL CAMBIAR POR LA QUE SEA DE ESE TIPO
	else:
		var room_scene = load("res://Scenes/Rooms/PreBuildedRooms/room" + str(Global.map[x][y]) +".tscn")
		currentRoom = room_scene.instantiate()

	currentRoom.position = Vector3(0, 0, 0)
	add_child(currentRoom)

# Limpiar puertas anteriores
func clean_previous_doors():
	for door in activeDoors:
		door.queue_free()
	activeDoors.clear()

	
func updateLevel():
	if Global.eraseLevel == true:
		Global.topCollider = false
		Global.botCollider = false
		Global.rightCollider = false
		Global.leftCollider = false
			
		# Limpiamos y regeneramos en lugar de reiniciar la escena
		clean_previous_doors()
		instanceRoom()
		generate_doors(Global.map)
		
		Global.eraseLevel = false  # Resetear la condición
		
func _ready():
	Global.eraseLevel = false
	if Global.isMapGenerated == false:
		map_generator(50, 8)

	generate_doors(Global.map)
	print_actual_pos(Global.map, Global.playerMapPositionX, Global.playerMapPositionY)
	instanceRoom()

func _process(delta):
	Global.actRoomChar = Global.map[Global.playerMapPositionX][Global.playerMapPositionY]
	updateLevel()


func set_global_stats():
	Global.rooms_visited.clear() # a la mierda las rooms visitadas
	Global.persistent_items.clear() # a la mierda los items del suelo

func set_all_colliders():
		Global.topCollider = false
		Global.botCollider = false
		Global.rightCollider = false
		Global.leftCollider = false
