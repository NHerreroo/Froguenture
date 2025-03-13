extends Node3D

@onready var nine_patch_rect = $CanvasLayer/NinePatchRect

func _ready() -> void:
	$AnimationPlayer.play("float")
	
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
		tween.tween_property(nine_patch_rect, "position", Vector2(644.0, 693.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 1.0, 0.2)
	else:
		tween.tween_property(nine_patch_rect, "position", Vector2(644.0, 693.0), 0.2)
		tween.parallel().tween_property(nine_patch_rect, "modulate:a", 0.0, 0.2)
		await tween.finished  # Esperar a que termine la animación antes de ocultarlo
		nine_patch_rect.visible = false  # Ocultar después de la animación


func set_controller_text():
	if Global.controller_active == true:
		$CanvasLayer/NinePatchRect/Text.text = str("Press 'O' to buy")
	else:
		$CanvasLayer/NinePatchRect/Text.text = str("Press 'E' to buy")
