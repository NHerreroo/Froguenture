extends Node

#--------------------------- VARIABLES PARA LA GENERACIN DEL MAPA----------------------

# DEFAULT

#var X_DIST := 100
#var Y_DIST := 100
#var PLACEMENT_RANDOMNESS := 5
#var FLOORS := 15
#var MAP_WIDTH := 7
#var PATHS := 6
#var MONSTERS_ROOM_WEIGHT := 30
#var SHOP_ROOM_WEIGHT := 30
#var CAMPFIRE_ROOM_WEIGHT := 30

var X_DIST = 100
var Y_DIST = 100
var PLACEMENT_RANDOMNESS = 5
var FLOORS = 5
var MAP_WIDTH = 3
var PATHS = 2
var MONSTERS_ROOM_WEIGHT = 30
var SHOP_ROOM_WEIGHT = 30
var CAMPFIRE_ROOM_WEIGHT = 30

#TUTORIAL VARS
var is_in_tutorial = true


var dialog_ended := true

var lvlCount = 0

var controller_active = false #el nombre lo dice todo AJAJA
var is_game_paused = false 
var card_focused = false

# posiciones del jugador real en la matrz del mapa, esta ira cambiando mientras pase por las puertas
# se utiliza para ver la posicion y generar la habitacion empieza en 25 por que el mapa siempre es de 50, el 25 indica el centro siempre empieza ahi
var playerMapPositionX = 25
var playerMapPositionY = 25
var actRoomChar

#bool para saber si se ha generado el mapa y no volver a generar hasta q se pase el boss
#el errase level es para desinstanciar la habitación y las puertas y volver a generarlas
var isMapGenerated = false
var eraseLevel = false
var specialRooms = false #variable para saber si la room que toca en el mapa es una que NO es de enemigos (tiendas, tesoros, campfires...)

#funciones globales para hacer trigger de las collsiones en caso de no haber habitaciones a los lados (uso solo en el LevelGnerator que genera el mapa)
var topCollider = false
var botCollider = false
var rightCollider = false
var leftCollider = false



var enemies_remaining = 0 #enemigos en pantalla restantes, si es 0 la habitacion estara abierta permantentemente :D
var NavRegion; #esto para los enemigos pa saber la zona por la que pueeden camnar y la que no
var rooms_visited = []
var Apersistent_items = []

#items de la tienda persistentes si cambias de room
var shopItem1
var shopItem2
var shopItem1Purchased = false
var shopItem2Purchased = false

#lo mismo que los alteares de tienda pero para tesoro
var treasureItem
var treasureItemPurchased = false

#RUN STATS
var run_time = 0
var run_total_kills = 0


var map = [] #contiene el mapa generado para que al reinicial la escena no se pierda

var playerDirection = 4; # lo uso para saber la direccion en la que aprece en una sala, modifico esta variable entrando en puertas
# 0 = arriba, 1 abajo, 2 izaquierda, 3 derecha 4 = centro y para saber la direccion en la que esta mirando el jugador


var pointer_click = false #cuando esta en el mapa si se pulsa X con mando se pone true pero se vuelve a poner en false (solo al tocar)


# PLAYER VARIABLES 
var card_selected = false #controlador para comprobar si se ha seleccionado la carta en la seleccion de item

var can_walk = true #cuando quiera que el personaje no camine se pone a false
var CurrentPlayerPosition = Vector2()
var eraseLife = false

var runEnded = false

var debilited = false #boss
var defeated = false

#VARIABLES PARA GUARDAS
var totalSeeds = 0
var totalTime = 0
var totalKills = 0
var totalRuns = 0
var totalFloors = 0




# -------------------- SISTEMA DE PERSISTENCIA DE ITEMS ------------------------
var persistent_items := {}

func add_item_to_room(room_x: int, room_y: int, item_type: String, position: Vector3):
	var room_key = "%d,%d" % [room_x, room_y]
	if not persistent_items.has(room_key):
		persistent_items[room_key] = []

	persistent_items[room_key].append({
		"type": item_type,
		"position": position
	})
	print(persistent_items)

func get_items_in_room(room_x: int, room_y: int) -> Array:
	var room_key = "%d,%d" % [room_x, room_y]
	return persistent_items.get(room_key, [])

	
func remove_item_from_room(room_x: int, room_y: int, position: Vector3):
	var room_key = "%d,%d" % [room_x, room_y]
	if not persistent_items.has(room_key): return
	
	persistent_items[room_key] = persistent_items[room_key].filter(func(item):
		return item.position != position)



func resetall():
	can_walk = true
	is_in_tutorial = false
	dialog_ended = true
	playerMapPositionX = 25
	playerMapPositionY = 25
	isMapGenerated = false
	eraseLevel = false
	specialRooms = false 
	topCollider = false
	botCollider = false
	rightCollider = false
	leftCollider = false
	treasureItem = null
	shopItem1 = null
	shopItem2 = null
	shopItem1Purchased = false
	shopItem2Purchased = false
	treasureItemPurchased = false
	enemies_remaining = 0 
	rooms_visited = []
	Apersistent_items = []
	map = [] 
	run_total_kills = 0
	debilited = false #boss
	defeated = false
	runEnded = false



func setMapDificulty():
	if totalSeeds >= 5:
		X_DIST = 100
		Y_DIST = 100
		PLACEMENT_RANDOMNESS = 5
		FLOORS = 8
		MAP_WIDTH = 5
		PATHS = 3
		MONSTERS_ROOM_WEIGHT = 30
		SHOP_ROOM_WEIGHT = 30
		CAMPFIRE_ROOM_WEIGHT = 30
	if totalSeeds >= 10:
		X_DIST = 100
		Y_DIST = 100
		PLACEMENT_RANDOMNESS = 5
		FLOORS = 12
		MAP_WIDTH = 7
		PATHS = 4
		MONSTERS_ROOM_WEIGHT = 30
		SHOP_ROOM_WEIGHT = 30
		CAMPFIRE_ROOM_WEIGHT = 30
	if totalSeeds >= 15:
		X_DIST = 100
		Y_DIST = 100
		PLACEMENT_RANDOMNESS = 7
		FLOORS = 15
		MAP_WIDTH = 6
		PATHS = 4
		MONSTERS_ROOM_WEIGHT = 30
		SHOP_ROOM_WEIGHT = 30
		CAMPFIRE_ROOM_WEIGHT = 30
