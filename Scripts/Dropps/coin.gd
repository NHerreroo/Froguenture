extends Area3D

func _ready() -> void:
	var room_position = [Global.playerMapPositionX, Global.playerMapPositionY]
	var coin_position = [position.x, position.y, position.z]

	# Buscar si la habitación ya existe en persistent_items
	for room_items in Global.persistent_items:
		if room_items[0] == room_position:
			# Verificar si ya existe una moneda en la misma posición
			for i in range(1, room_items.size()):
				var item = room_items[i]
				if item is Array and item.size() >= 4:
					if item[0] == "Coin" and item[1] == coin_position[0] and item[2] == coin_position[1] and item[3] == coin_position[2]:
						return  # Moneda ya existe, salir de la función

			
			# Insertar la moneda en la lista de objetos de la habitación
				room_items.append(["Coin", coin_position[0], coin_position[1], coin_position[2]])
				print("Moneda añadida:", Global.persistent_items)
				return

	# Si la habitación no existe, crearla con la moneda como primer objeto
	Global.persistent_items.append([room_position, ["Coin", coin_position[0], coin_position[1], coin_position[2]]])
	print("Nueva habitación creada:", Global.persistent_items)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var coin_position = [position.x, position.y, position.z]

		# Buscar y eliminar la moneda en Global.persistent_items
		for room_items in Global.persistent_items:
			if room_items[0] == [Global.playerMapPositionX, Global.playerMapPositionY]:
				# Buscar la moneda en esa habitación
				for i in range(1, room_items.size()):
					var item = room_items[i]
					if item is Array and item.size() >= 4:
						# Si es una moneda y tiene la misma posición, eliminarla
						if item[0] == "Coin" and item[1] == coin_position[0] and item[2] == coin_position[1] and item[3] == coin_position[2]:
							room_items.remove_at(i)  # Ewwwliminar la moneda de la lista
							print("Moneda eliminada:", Global.persistent_items)
							Global.money += 1
							queue_free()  # Eliminar el nodo de la escena
							return
