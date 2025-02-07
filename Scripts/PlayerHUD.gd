extends Control

@onready var heart_container_node = $CanvasLayer/HeartContainer  # Nodo donde se dibujan los corazones
@onready var heart_scene = preload("res://Scenes/heart_hud.tscn")  # Escena del sprite de corazón
@onready var shield_scene = preload("res://Scenes/shield_hud.tscn")  # Escena del sprite de escudo

func _process(delta):
	update_hearts()

func update_hearts():
	print("Actualizando corazones...")  # Mensaje de depuración
	if heart_container_node == null:
		print("Error: heart_container_node no está inicializado.")  # Mensaje de depuración
		return

	# Limpia los corazones actuales
	for child in heart_container_node.get_children():
		child.queue_free()

	# Añade los corazones rojos
	var health = Player.health
	var health_container = Player.health_container
	print("Salud: ", health, " Contenedores de salud: ", health_container)  # Mensaje de depuración
	for i in range(health_container):
		var heart = heart_scene.instantiate()
		if health >= 1:
			heart.set_full()  # Corazón lleno
			health -= 1
		elif health >= 0.5:
			heart.set_half()  # Medio corazón
			health -= 0.5
		else:
			heart.set_empty()  # Corazón vacío
		heart_container_node.add_child(heart)
		print("Corazón añadido: ", heart)  # Mensaje de depuración

	# Añade los corazones azules (escudos)
	var shield = Player.shield
	print("Escudos: ", shield)  # Mensaje de depuración
	while shield > 0:
		var shield_heart = shield_scene.instantiate()
		if shield >= 1:
			shield_heart.set_full()
			shield -= 1
		else:
			shield_heart.set_half()
			shield -= 0.5
		heart_container_node.add_child(shield_heart)
		print("Escudo añadido: ", shield_heart)  # Mensaje de depuración
