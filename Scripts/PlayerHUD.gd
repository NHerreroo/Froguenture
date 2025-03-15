extends Control

@onready var heart_container_node = $CanvasLayer/PlayerLife  # Nodo donde se dibujan los corazones
@onready var heart_scene = preload("res://Scenes/heart_hud.tscn")  # Escena del sprite de corazón
@onready var shield_scene = preload("res://Scenes/shield_hud.tscn")  # Escena del sprite de escudo

func _process(delta: float) -> void:
	$HudLabels/MONEDAS.text = str(Player.money)

func _ready() -> void:
	# Conectar la señal del singleton Player
	Player.connect("health_updated", Callable(self, "update_hearts"))
	# Llamar a update_hearts() al inicio para mostrar la vida inicial
	update_hearts()

func update_hearts():
	print("La vida está actualizada")  # Mensaje de depuración

	# Limpiar todos los nodos hijos de heart_container_node antes de volver a dibujar
	for child in heart_container_node.get_children():
		child.queue_free()  # Elimina cada nodo hijo

	# Crear un array para almacenar los strings de corazones y escudos
	var hearts_and_shields = []

	# Añadir corazones rojos al array
	var health = Player.health
	var health_container = Player.health_container
	for i in range(health_container):
		if health >= 1:
			hearts_and_shields.append("full_heart")  # Corazón lleno
			health -= 1
		elif health >= 0.5:
			hearts_and_shields.append("half_heart")  # Medio corazón
			health -= 0.5
		else:
			hearts_and_shields.append("empty_heart")  # Corazón vacío

	# Añadir escudos azules al array
	var shield = Player.shield
	while shield > 0:
		if shield >= 1:
			hearts_and_shields.append("full_shield")  # Escudo lleno
			shield -= 1
		else:
			hearts_and_shields.append("half_shield")  # Medio escudo
			shield -= 0.5

	# Ordenar el array según el criterio: full_heart > half_heart > empty_heart > full_shield > half_shield
	hearts_and_shields.sort_custom(func(a, b):
		var order = ["full_heart", "half_heart", "empty_heart", "full_shield", "half_shield"]
		return order.find(a) < order.find(b)
	)

	# Limitar el número total de elementos a 12
	if hearts_and_shields.size() > 12:
		hearts_and_shields = hearts_and_shields.slice(0, 12)

	# Dibujar los corazones y escudos en el HUD
	var start_x = 80  # Posición inicial en X
	var start_y = 36   # Posición inicial en Y
	var offset_x = 100 # Desplazamiento en X entre cada corazón/escudo
	var offset_y = 100 # Desplazamiento en Y para la segunda fila

	for i in range(hearts_and_shields.size()):
		var item = hearts_and_shields[i]

		# Cambiar a la segunda fila después del 6to elemento
		if i == 6:  # Cuando llegamos al 7mo elemento
			start_x = 80  # Reiniciar la posición X para la segunda fila
			start_y += offset_y  # Mover hacia abajo en Y

		match item:
			"full_heart":
				var heart = heart_scene.instantiate()
				heart.set_full()
				heart.position = Vector2(start_x, start_y)
				heart_container_node.add_child(heart)
			"half_heart":
				var heart = heart_scene.instantiate()
				heart.set_half()
				heart.position = Vector2(start_x, start_y)
				heart_container_node.add_child(heart)
			"empty_heart":
				var heart = heart_scene.instantiate()
				heart.set_empty()
				heart.position = Vector2(start_x, start_y)
				heart_container_node.add_child(heart)
			"full_shield":
				var shield_heart = shield_scene.instantiate()
				shield_heart.set_full()
				shield_heart.position = Vector2(start_x, start_y)
				heart_container_node.add_child(shield_heart)
			"half_shield":
				var shield_heart = shield_scene.instantiate()
				shield_heart.set_half()
				shield_heart.position = Vector2(start_x, start_y)
				heart_container_node.add_child(shield_heart)

		# Incrementar la posición en X para el siguiente corazón/escudo
		start_x += offset_x
