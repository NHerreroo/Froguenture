extends Node3D

@onready var nine_patch_rect = $CanvasLayer/NinePatchRect
@onready var item_sprite = $Item
var dust = preload("res://Scenes/Enemies/dust.tscn")
var pack = preload("res://Items/ItemCardSelector.tscn")

var items = {
	"PACK": {"price": 0, "icon": preload("res://Sprites/icons/PACK.png"), "probability": 10},
	"COLLECTOR": {"price": 0, "icon": preload("res://Sprites/icons/BOOSTER.png"), "probability": 30},
}

var item_effects = {
	"PACK": func(): spawn_pack(),
	"COLLECTOR": func(): spawn_pack(),
}


var currentItem : String
var playerInArea = false
var disableShop = false

func _ready() -> void:
	$AnimationPlayer.play("float")
	
	# Solo se generarán los ítems si no están ya en Global
	if Global.treasureItem == null:
		Global.treasureItem = get_random_item()
	
	currentItem = Global.treasureItem
	
	set_item()

func _process(delta: float) -> void:
	set_controller_text()
	if Global.treasureItemPurchased:
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
			
			
			Global.treasureItemPurchased = true
			
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
		var boxText = "Get " + str(currentItem) + " for free!" 
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
	
