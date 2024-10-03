extends Node

#cargo las escenas de las puertas para poder hacer la instancia
var topDoor = preload("res://Scenes/Doors/TopDoor.tscn")
var bottomDoor = preload("res://Scenes/Doors/BottomDoor.tscn")
var leftDoor = preload("res://Scenes/Doors/LeftDoor.tscn")
var rightDoor = preload("res://Scenes/Doors/RightDoor.tscn")


#cargo las escenas de todas las habitaciones para poder instanciarlas dependiendo la posicion del array
var initRoom = preload("res://Scenes/Rooms/initialRoom.tscn")
var room1 = preload("res://Scenes/Rooms/room1.tscn")

# Constates Char para las salas
var ROOM = ''
const SHOP = '$'
const BOSS = 'X'
const TREASURE = '#'
const FIRST_ROOM = '@'
const EMPTY = ' '
var map

func defaultRoomGen():
	var randRoom = randi_range(1,2)
	ROOM = str(randRoom)

func map_generator(map_size: int, steps: int) -> void: # le paso parametros tamaño y pasos (salas a generar) los mapas se generan mas grandes a medida que se avanza
	Global.map = []  # Crear la matriz del mapa 
	
	# creo la matriz con espacios vacíos
	for i in range(map_size):
		Global.map.append([])  # Crear una nueva fila
		for j in range(map_size):
			Global.map[i].append(EMPTY)  # llenar la fila con espacios vacíos
			

	var walker_pos_x = map_size / 2 # define la posicion inical del walker q es el centro de la matriz
	var walker_pos_y = map_size / 2
	

	# creo dos variables para generar un numero random, este numero indica que al step X me genere la sala Shop o Treasure
	var shop_room = randi_range(1, steps - 2) 
	var treasure_room = randi_range(1, steps - 2)

	# el centro de la matriz se marca con el @ para indicar que es la sala inicial
	Global.map[walker_pos_x][walker_pos_y] = FIRST_ROOM

	# contador de pasos
	var step_count = 1  # se inicia en 1 dando a enteder que la primera ya esta marcada como si fuera un step

	# generar el moviemento del drunked walk
	while step_count < steps:
		var direction = randi() % 4 
		var new_pos_x = walker_pos_x
		var new_pos_y = walker_pos_y

		# Mover el caminante en una dirección aleatoria
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

		# solo cuenta el paso si la nueva casilla no ha sido marcada
		if Global.map[new_pos_x][new_pos_y] == EMPTY:
			walker_pos_x = new_pos_x
			walker_pos_y = new_pos_y
			
			# filtro para detectar que sala toca generar
			if step_count == steps - 1:
				Global.map[walker_pos_x][walker_pos_y] = BOSS  # ultima posición es el boss
			elif step_count == shop_room:
				Global.map[walker_pos_x][walker_pos_y] = SHOP
			elif step_count == treasure_room:
				Global.map[walker_pos_x][walker_pos_y] = TREASURE
			else:
				defaultRoomGen()
				Global.map[walker_pos_x][walker_pos_y] = ROOM  # sala default

			step_count += 1  # cuenta 1 al contador de pasos
			
	print_map(Global.map)
	
	Global.isMapGenerated = true

# print de la mtriz
func print_map(map: Array) -> void:
	for row in Global.map:
		print("".join(row))
		

func print_actual_pos(map: Array, x: int, y:int):
	print("actual position = " + Global.map[x][y])
	
func generate_doors(map: Array): #detecta si hay habitaciones a los lados de la actual y si hay, las instancia
	var x = Global.playerMapPositionX
	var y = Global.playerMapPositionY
	Global.map[x][y]
	if Global.map[x + 1][y] != ' ':
		var bottomDoorInst = bottomDoor.instantiate()
		bottomDoorInst.position = Vector3(5,0,0)
		add_child(bottomDoorInst)
	if Global.map[x - 1][y] != ' ':
		var topDoorInst = topDoor.instantiate()
		topDoorInst.position = Vector3(-5,0,0)
		add_child(topDoorInst)
	if Global.map[x][y + 1] != ' ':
		var rightDoorInst = rightDoor.instantiate()
		rightDoorInst.position = Vector3(0,0,-8)
		add_child(rightDoorInst)
	if Global.map[x][y - 1] != ' ':
		var leftDoorInst = leftDoor.instantiate()
		leftDoorInst.position = Vector3(0,0,8)
		add_child(leftDoorInst)
		
		
func instanceRoom():
	var x = Global.playerMapPositionX
	var y = Global.playerMapPositionY
	if Global.map[x][y] == '@':
		var initRoomInst = initRoom.instantiate()
		initRoomInst.position = Vector3(0,0,0)
		add_child(initRoomInst)
	else:
		var room1Inst = room1.instantiate()
		room1Inst.position = Vector3(0,0,0)
		add_child(room1Inst)
		

func _ready():
	Global.eraseLevel = false
	if Global.isMapGenerated == false: # si el mapa no esta generado lo genera
		map_generator(10, 8) 
	generate_doors(Global.map) #llama a la func que genera las puertas
	print_actual_pos(Global.map, Global.playerMapPositionX, Global.playerMapPositionY)
	instanceRoom()	#llama a la func que genera la habitacion pensando en el punto en el que esta de la matriz
	
func _process(delta):
	if Global.eraseLevel == true:
		get_tree().reload_current_scene()
