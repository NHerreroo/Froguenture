extends Control

@onready var heart_container_node = $CanvasLayer/PlayerLife
@onready var heart_scene = preload("res://Scenes/heart_hud.tscn")
@onready var shield_scene = preload("res://Scenes/shield_hud.tscn")

# aicc para guardad stats
var previous_values = {
	"money": 0,
	"atack": 0,
	"criticalDamage": 0,
	"dashCooldown": 0,
	"poisonDamage": 0,
	"speed": 0,
	"atackSpeed": 0
}
	#valores de antes
func _ready() -> void:
	# Guardar valores iniciales
	previous_values["money"] = Player.money
	previous_values["atack"] = Player.atack
	previous_values["criticalDamage"] = Player.criticalDamage
	previous_values["dashCooldown"] = Player.dashCooldown
	previous_values["poisonDamage"] = Player.poisonDamage
	previous_values["speed"] = Player.speed
	previous_values["atackSpeed"] = Player.atackSpeed

	# actualizar todas las labels al inicio
	$HudLabels/MONEDAS.text = str(Player.money)
	$HudLabels/Attack.text = str(Player.atack)
	$HudLabels/Critcal.text = str(Player.criticalDamage)
	$HudLabels/DashCooldown.text = str(Player.dashCooldown)
	$HudLabels/Poison.text = str(Player.poisonDamage)
	$HudLabels/Speed.text = str(Player.speed)
	$HudLabels/SpeedAttack.text = str(Player.atackSpeed)

	Player.connect("health_updated", Callable(self, "update_hearts"))
	update_hearts()

func _process(delta: float) -> void:
	# Actualizar cada label para q se vea con el efecto de color
	update_label_with_effect($HudLabels/MONEDAS, "money", Player.money if Player.get("money") != null else 0)
	update_label_with_effect($HudLabels/Attack, "atack", Player.atack if Player.get("atack") != null else 0)
	update_label_with_effect($HudLabels/Critcal, "criticalDamage", Player.criticalDamage if Player.get("criticalDamage") != null else 0)
	update_label_with_effect($HudLabels/DashCooldown, "dashCooldown", Player.dashCooldown if Player.get("dashCooldown") != null else 0)
	update_label_with_effect($HudLabels/Poison, "poisonDamage", Player.poisonDamage if Player.get("poisonDamage") != null else 0)
	update_label_with_effect($HudLabels/Speed, "speed", Player.speed if Player.get("speed") != null else 0)
	update_label_with_effect($HudLabels/SpeedAttack, "atackSpeed", Player.atackSpeed if Player.get("atackSpeed") != null else 0)

#updateamos la label con el valor q le toca y le hacemos el cambio de colorinininin ME FOKIN VUELVO LOCO DIOS
func update_label_with_effect(label: Label, stat_name: String, current_value: float) -> void:
	if previous_values[stat_name] != current_value:
		if current_value > previous_values[stat_name]:
			label.modulate = Color.GREEN
		elif current_value < previous_values[stat_name]:
			label.modulate = Color.RED
		label.text = str(current_value)
		var tween = create_tween()
		tween.tween_property(label, "modulate", Color.WHITE, 1.5)
		previous_values[stat_name] = current_value

func update_hearts():
	for child in heart_container_node.get_children():
		child.queue_free()
		
	var hearts_and_shields = []
	
	var health = Player.health if Player.get("health") != null else 0
	var health_container = Player.health_container if Player.get("health_container") != null else 0
	for i in range(health_container):
		if health >= 1: 
			hearts_and_shields.append("full_heart")  
			health -= 1
		elif health >= 0.5:
			hearts_and_shields.append("half_heart") 
			health -= 0.5
		else:
			hearts_and_shields.append("empty_heart") 
			
	var shield = Player.shield if Player.get("shield") != null else 0
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
