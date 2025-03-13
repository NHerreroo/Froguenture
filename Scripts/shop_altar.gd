extends Node3D

@onready var nine_patch_rect = $CanvasLayer/NinePatchRect
var dust = preload("res://Scenes/Enemies/dust.tscn")

# Diccionario con ítems, precios, iconos y probabilidades
var items = {
	"PACK": {"price": 15, "icon": preload("res://Sprites/icons/PACK.png"), "probability": 10},
	"COLLECTOR": {"price": 20, "icon": preload("res://Sprites/icons/BOOSTER.png"), "probability": 5},
	"HEART": {"price": 5, "icon": preload("res://Sprites/icons/heart.png"), "probability": 30},
	"SHIELD": {"price": 5, "icon": preload("res://Sprites/icons/shield.png"), "probability": 25},
	"SPEED": {"price": 10, "icon": preload("res://Sprites/icons/speed.png"), "probability": 15},
	"ATTACK": {"price": 10, "icon": preload("res://Sprites/icons/Atack.png"), "probability": 10},
	"ATTACKSPEED": {"price": 10, "icon": preload("res://Sprites/icons/speedatack.png"), "probability": 5},
	"CRITICALDMG": {"price": 10, "icon": preload("res://Sprites/icons/Atack.png"), "probability": 5},
	"CRITICALCHANCE": {"price": 10, "icon": preload("res://Sprites/icons/Atack.png"), "probability": 2}
}

func _ready() -> void:
	$AnimationPlayer.play("float")
	get_random_item()

func _process(delta: float) -> void:
	set_controller_text()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		spawn_dust()
		animate_nine_patch_rect(true)
		queue_free()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		animate_nine_patch_rect(false)

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
	if Global.controller_active == true:
		$CanvasLayer/NinePatchRect/Text.text = "Press 'O' to buy"
	else:
		$CanvasLayer/NinePatchRect/Text.text = "Press 'E' to buy"

func get_random_item():
	var total_probability = 0
	for item in items.values():
		total_probability += item.probability
	
	var random_value = randi() % total_probability
	var cumulative = 0
	
	for key in items.keys():
		cumulative += items[key].probability
		if random_value < cumulative:
			var current_item = items[key]
			$CanvasLayer/NinePatchRect/Price.text = str(current_item.price)
			$Item.texture = current_item.icon
			return


func spawn_dust():
	var dust_inst = dust.instantiate()
	dust_inst.position = Vector3(self.position.x, 0 ,self.position.z)
	get_tree().root.add_child(dust_inst)
