extends Control

@onready var heart_container_node = $CanvasLayer/PlayerLife # Nodo donde se dibujan los corazones
@onready var heart_scene = preload("res://Scenes/heart_hud.tscn")  # Escena del sprite de corazón
@onready var shield_scene = preload("res://Scenes/shield_hud.tscn")  # Escena del sprite de escudo

var hearts_and_shields = []

func _ready() -> void:
	update_hearts()
	print(hearts_and_shields)

func update_hearts():
	hearts_and_shields = []

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

	# Dibujar los corazones y escudos en el HUD
	var start_x = 144  # Posición inicial en X
	var start_y = 96   # Posición inicial en Y
	var offset_x = 100 # Desplazamiento en X entre cada corazón/escudo

	for item in hearts_and_shields:
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
