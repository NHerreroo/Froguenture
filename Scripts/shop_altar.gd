extends Node3D

@onready var nine_patch_rect = $CanvasLayer/NinePatchRect
@onready var item_sprite = $Item
var dust = preload("res://Scenes/Enemies/dust.tscn")
var pack = preload("res://Items/ItemCardSelector.tscn")

var items = {
	"PACK": {"price": 10, "icon": preload("res://Sprites/icons/PACK.png"), "probability": 15},
	"COLLECTOR": {"price": 15, "icon": preload("res://Sprites/icons/BOOSTER.png"), "probability": 10},
	"HEART": {"price": 5, "icon": preload("res://Sprites/icons/heart.png"), "probability": 30},
	"SHIELD": {"price": 5, "icon": preload("res://Sprites/icons/shield.png"), "probability": 25},
	"SPEED": {"price": 10, "icon": preload("res://Sprites/icons/speed.png"), "probability": 15},
	"ATTACK": {"price": 10, "icon": preload("res://Sprites/icons/Atack2.png"), "probability": 15},
	"ATTACKSPEED": {"price": 10, "icon": preload("res://Sprites/icons/speedatack.png"), "probability": 5},
	"CRITICALDMG": {"price": 10, "icon": preload("res://Sprites/icons/Atack.png"), "probability": 5},
	"CRITICALCHANCE": {"price": 10, "icon": preload("res://Sprites/icons/Atack.png"), "probability": 2}
}

var item_effects = {
	"PACK": func(): spawn_pack(),
	"COLLECTOR": func(): spawn_pack(),
	"HEART": func():
		Player.health += 1.0 
		Player.notify_health_updated(),
	"SHIELD": func(): 
		Player.shield += 1.0 
		Player.notify_health_updated(),
	"SPEED": func(): Player.speed += 0.2,
	"ATTACK": func(): Player.atack += 0.3,
	"ATTACKSPEED": func(): Player.atackSpeed += 0.1,
	"CRITICALDMG": func(): Player.criticalDamage += 0.3,
	"CRITICALCHANCE": func(): Player.atack += 0.3
}


var currentItem : String
var playerInArea = false
var disableShop = false

func _ready() -> void:
	$AnimationPlayer.play("float")
	
	# Solo se generarán los ítems si no están ya en Global
	if Global.shopItem1 == null:
		Global.shopItem1 = get_random_item()
	if Global.shopItem2 == null:
		Global.shopItem2 = get_random_item()
	
	if self.name == "Altar1":
		currentItem = Global.shopItem1
	
	elif self.name == "Altar2":
		currentItem = Global.shopItem2

	set_item()

func _process(delta: float) -> void:
	set_controller_text()
	
	if self.name == "Altar1":
		if Global.shopItem1Purchased:
			item_sprite.visible = false
			animate_nine_patch_rect(false)
			$Area3D/CollisionShape3D.disabled = true
	elif self.name == "Altar2":
		if Global.shopItem2Purchased:
			item_sprite.visible = false
			animate_nine_patch_rect(false)
			$Area3D/CollisionShape3D.disabled = true
	if playerInArea:
		buy_item()
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animate_nine_patch_rect(true)
		playerInArea = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		animate_nine_patch_rect(false)
		playerInArea = false

func buy_item():
	var item_data = items.get(currentItem, null)
	if item_data and Input.is_action_just_pressed("Confirm"):
		if Player.money >= item_data.price:
			Player.money -= item_data.price
			spawn_dust()
			animate_nine_patch_rect(false)
			
			if self.name == "Altar1":
				Global.shopItem1Purchased = true
			elif self.name == "Altar2":
				Global.shopItem2Purchased = true
			if currentItem in item_effects:
				item_effects[currentItem].call()  

func animate_nine_patch_rect(show: bool) -> void:
	var tween = create_tween().set_parallel(true)
	if show:
		nine_patch_rect.visible = true
		tween.tween_property(nine_patch_rect, "position", Vector2(485.0, 796.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 1.0, 0.2)
	else:
		tween.tween_property(nine_patch_rect, "position", Vector2(485.0, 796.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 0.0, 0.2)
		await tween.finished
		nine_patch_rect.visible = false

func set_controller_text():
	if Global.controller_active:
		$CanvasLayer/NinePatchRect/Text.text = "Press 'O' to buy"
	else:
		$CanvasLayer/NinePatchRect/Text.text = "Press 'E' to buy"

#setear el item una vez establecido que item es
func set_item():
	if currentItem in items:
		var item_data = items[currentItem]
		var boxText = "Purchase " + str(currentItem) + " for: " + str(item_data.price) + "$" 
		$CanvasLayer/NinePatchRect/Price.text = str(boxText)
		$Item.texture = item_data.icon
	else:
		print("El ítem", currentItem, "no existe en el diccionario.")

# devuelve item reandom
func get_random_item() -> String:
	var total_probability = 0
	for item in items.values():
		total_probability += item.probability
	
	var random_value = randi() % total_probability
	var cumulative = 0
	
	for key in items.keys():
		cumulative += items[key].probability
		if random_value < cumulative:
			return key
	return ""

func spawn_dust():
	var dust_inst = dust.instantiate()
	dust_inst.position = Vector3(self.position.x, 0 ,self.position.z)
	get_tree().root.add_child(dust_inst)
	
	
func spawn_pack():
	var pack_inst = pack.instantiate()  # Instancia el objeto
	pack_inst.position = Vector2(292, 184)
	
	add_child(pack_inst)
