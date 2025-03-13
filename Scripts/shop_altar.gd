extends Node3D

@onready var nine_patch_rect = $CanvasLayer/NinePatchRect


var items = {
	"PACK": {"price": 100, "description": "A useful pack.", "rarity": "common"},
	"COLLECTOR": {"price": 200, "description": "Collects nearby items.", "rarity": "rare"},
	"HEART": {"price": 50, "description": "Restores health.", "rarity": "common"},
	"SHIELD": {"price": 150, "description": "Provides temporary shield.", "rarity": "rare"},
	"SPEED": {"price": 120, "description": "Increases movement speed.", "rarity": "uncommon"},
	"ATTACK": {"price": 180, "description": "Boosts attack power.", "rarity": "uncommon"},
	"ATTACKSPEED": {"price": 170, "description": "Increases attack speed.", "rarity": "uncommon"},
	"CRITICALDMG": {"price": 250, "description": "Increases critical damage.", "rarity": "rare"},
	"CRITICALCHANCE": {"price": 230, "description": "Increases critical hit chance.", "rarity": "rare"}
}


func _ready() -> void:
	$AnimationPlayer.play("float")
	var keys = items.keys()
	var specific_key = keys[2]  # Índice 2 (tercer elemento)
	var current_item = items[specific_key]
	print(current_item.price)

func _process(delta: float) -> void:
	set_controller_text()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		animate_nine_patch_rect(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		animate_nine_patch_rect(false)

func animate_nine_patch_rect(show: bool) -> void:
	var tween = create_tween().set_parallel(true)  # Crear un nuevo Tween cada vez

	if show:
		nine_patch_rect.visible = true
		tween.tween_property(nine_patch_rect, "position", Vector2(485.0, 796.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 1.0, 0.2)
	else:
		tween.tween_property(nine_patch_rect, "position", Vector2(485.0, 796.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 0.0, 0.2)
		await tween.finished  # Esperar a que termine la animación antes de ocultarlo
		nine_patch_rect.visible = false  # Ocultar después de la animación


func set_controller_text():
	if Global.controller_active == true:
		$CanvasLayer/NinePatchRect/Text.text = str("Press 'O' to buy")
	else:
		$CanvasLayer/NinePatchRect/Text.text = str("Press 'E' to buy")


	
