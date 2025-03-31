extends Control

@onready var heart_container_node = $CanvasLayer/PlayerLife  # Nodo donde se dibujan los corazones
@onready var heart_scene = preload("res://Scenes/heart_hud.tscn")  # Escena del sprite de corazón
@onready var shield_scene = preload("res://Scenes/shield_hud.tscn")  # Escena del sprite de escudo

func _process(delta: float) -> void:
	$HudLabels/MONEDAS.text = str(Player.money)
	$HudLabels/Attack.text = str(Player.atack)
	$HudLabels/Critcal.text = str(Player.criticalDamage)
	$HudLabels/DashCooldown.text = str(Player.dashCooldown)
	$HudLabels/Poison.text = str(Player.poisonDamage)
	$HudLabels/Speed.text = str(Player.speed)
	$HudLabels/SpeedAttack.text = str(Player.atackSpeed)


func _ready() -> void:
	# Conectar la señal del singleton Player
	Player.connect("health_updated", Callable(self, "update_hearts"))
	# Llamar a update_hearts() al inicio para mostrar la vida inicial
	update_hearts()

func update_hearts():
	for child in heart_container_node.get_children():
		child.queue_free()  # Elimina cada nodo hijo

	var hearts_and_shields = []

	# Añadir corazones rojos al array
	var health = Player.health
	var health_container = Player.health_container
	for i in range(health_container):
		if health >= 1:
			hearts_and_shields.append("full_heart")  
			health -= 1
		elif health >= 0.5:
			hearts_and_shields.append("half_heart") 
			health -= 0.5
		else:
			hearts_and_shields.append("empty_heart") 

	var shield = Player.shield
	while shield > 0:
		if shield >= 1:
			hearts_and_shields.append("full_shield")  
			shield -= 1
		else:
			hearts_and_shields.append("half_shield") 
			shield -= 0.5

	hearts_and_shields.sort_custom(func(a, b):
		var order = ["full_heart", "half_heart", "empty_heart", "full_shield", "half_shield"]
		return order.find(a) < order.find(b)
	)

	if hearts_and_shields.size() > 12:
		hearts_and_shields = hearts_and_shields.slice(0, 12)

	# Dibujar los corazones y escudos en el HUD
	var start_x = 80  
	var start_y = 36   
	var offset_x = 100
	var offset_y = 100

	for i in range(hearts_and_shields.size()):
		var item = hearts_and_shields[i]

		
		if i == 6: 
			start_x = 80  
			start_y += offset_y 

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

		start_x += offset_x
