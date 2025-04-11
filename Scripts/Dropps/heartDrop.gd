extends Area3D

func _ready() -> void:
	$AnimationPlayer.play("idle")
	var room_position = [Global.playerMapPositionX, Global.playerMapPositionY]
	var heart_position = [position.x, position.y, position.z]

	# Buscar si la habitación ya existe en persistent_items
	for room_items in Global.persistent_items:
		if room_items[0] == room_position:
			# Verificar si ya existe un corazon en la misma posición
			for i in range(1, room_items.size()):
				var item = room_items[i]
				if item is Array and item.size() >= 4:
					if item[0] == "Heart" and item[1] == heart_position[0] and item[2] == heart_position[1] and item[3] == heart_position[2]:
						return  # corazon ya existe, salir de la función

			
			# Insertar el corazon en la lista de objetos de la habitación
				room_items.append(["Heart", heart_position[0], heart_position[1], heart_position[2]])
				return

	# Si la habitación no existe, crearla con el corazon como primer objeto
	#Global.persistent_items.append([room_position, ["Heart", heart_position[0], heart_position[1], heart_position[2]]])

func _on_body_entered(body: Node3D) -> void:
	if Player.health >= Player.health_container:
		return
	if body.is_in_group("player"):
		var heart_position = [position.x, position.y, position.z]

		# Buscar y eliminar el corazon en Global.persistent_items
		for room_items in Global.persistent_items:
			if room_items[0] == [Global.playerMapPositionX, Global.playerMapPositionY]:
				# Buscar  el corazon en esa habitación
				for i in range(1, room_items.size()):
					var item = room_items[i]
					if item is Array and item.size() >= 4:
						# Si es un corazon y tiene la misma posición, eliminarla
						if item[0] == "Heart" and item[1] == heart_position[0] and item[2] == heart_position[1] and item[3] == heart_position[2]:
							room_items.remove_at(i)  # Ewwwliminar  el corazon de la lista
							Player.health += 1;
							Player.notify_health_updated()
							queue_free()  # Eliminar el nodo de la escena
							return
