extends Area3D

func _ready() -> void:
	$AnimationPlayer.play("idle")
	var room_position = [Global.playerMapPositionX, Global.playerMapPositionY]
	var shield_position = [position.x, position.y, position.z]

	# Buscar si la habitación ya existe en persistent_items
	for room_items in Global.persistent_items:
		if room_items[0] == room_position:
			# Verificar si ya existe un escudo en la misma posición
			for i in range(1, room_items.size()):
				var item = room_items[i]
				if item is Array and item.size() >= 4:
					if item[0] == "Shield" and item[1] == shield_position[0] and item[2] == shield_position[1] and item[3] == shield_position[2]:
						return  # escudo ya existe, salir de la función

			
			# Insertar escudo en la lista de objetos de la habitación
				room_items.append(["Shield", shield_position[0], shield_position[1], shield_position[2]])
				return

	# Si la habitación no existe, crearla con escuedo como primer objeto
	#Global.persistent_items.append([room_position, ["Shield", shield_position[0], shield_position[1], shield_position[2]]])

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if Player.health_container + Player.shield >= 12:
			return
		var shield_position = [position.x, position.y, position.z]

		# Buscar y eliminar escuido en Global.persistent_items
		for room_items in Global.persistent_items:
			if room_items[0] == [Global.playerMapPositionX, Global.playerMapPositionY]:
				# Buscar el shield en esa habitación
				for i in range(1, room_items.size()):
					var item = room_items[i]
					if item is Array and item.size() >= 4:
						if item[0] == "Shield" and item[1] == shield_position[0] and item[2] == shield_position[1] and item[3] == shield_position[2]:
							room_items.remove_at(i)  # Ewwwliminar la moneda de la lista
							Player.shield += 1;
							Player.notify_health_updated()
							queue_free()  # Eliminar el nodo de la escena
							return
