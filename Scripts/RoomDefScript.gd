extends Node3D

var player = null
var collilsions_seted = false

var sides = ["top", "bot", "right", "left"]


func _ready():
	player = get_tree().get_root().find_child("player", true, false)
	var current_room = [Global.playerMapPositionX, Global.playerMapPositionY]

	# Recorremos el array de habitaciones y objetos
	for room_items in Global.persistent_items:
		var room_position = room_items[0]

		# Comprobamos si la posición coincide con la habitación actual
		if room_position == current_room:
			print("Objetos en la habitación:", current_room)
			
			# Recorremos los objetos en esa posición (ignorando el primer elemento que es la posición)
			for item in room_items[1:]:
				var item_name = item[0]
				var pos_x = item[1]
				var pos_y = item[2]
				var pos_z = item[3]
				print("Objeto encontrado: %s posición (%d, %d, %d)" % [item_name, pos_x, pos_y, pos_z])
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
