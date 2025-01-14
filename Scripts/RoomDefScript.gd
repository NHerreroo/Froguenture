extends Node3D

var player = null
var collilsions_seted = false
var coin = preload("res://Scenes/Dropps/Coin.tscn")

var sides = ["top", "bot", "right", "left"]

func _ready() -> void:
	Global.eraseLevel = false
	var current_room = [Global.playerMapPositionX, Global.playerMapPositionY]
	player = get_tree().get_root().find_child("player", true, false)
	# Recorremos el array de habitaciones y objetos
	for room_items in Global.persistent_items:
		var room_position = room_items[0]
		# Comprobamos si la posición coincide con la habitación actual
		if room_position == current_room:
			# Iterar sobre los elementos del array desde el segundo elemento
			for i in range(1, room_items.size()):
				var item = room_items[i]
				if item is Array and item.size() >= 4:
					var item_name = item[0]
					var pos_x = item[1]
					var pos_y = item[2]
					var pos_z = item[3]
					if item_name == "Coin":
						var coin_instance = coin.instantiate()
						coin_instance.position = Vector3(pos_x, pos_y, pos_z)
						add_child(coin_instance)  # Agregar la moneda como hijo del nodo actual
			break

func _process(delta):
	if Global.enemies_remaining == 0:
		setCollisions()
	else:
		activateAllCollisions()
	
	if Global.eraseLevel == true:
		queue_free()

func setCollisions():
	for side in sides:
		var collider = $BoundsColliders/StaticBody3D.get_node(side + "btwn")
		collider.disabled = not Global.get(side + "Collider")
	collilsions_seted = true

func activateAllCollisions():
	for side in sides:
		var collider = $BoundsColliders/StaticBody3D.get_node(side + "btwn")
		collider.disabled = false
	collilsions_seted = false  
