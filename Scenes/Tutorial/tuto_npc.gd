extends Node3D

var player_in_range = false
var dialog = preload("res://Scenes/TextBox.tscn")
var fade_speed := 6 # Velocidad del fade (ajustable)

func _ready() -> void:
	$Sprite3D/TextBoxSystem.start_dialog("res://Dialogs/Tutorial1.txt")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false

func _input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("Confirm") and Global.dialog_ended:
		var newDialog = dialog.instantiate()
		newDialog.position = Vector3(4.049, 2.59, -1.38)
		add_child(newDialog)
		newDialog.start_dialog("res://Dialogs/Tutorial1.txt")
		Global.dialog_ended = false
		get_viewport().set_input_as_handled()

func _process(delta: float) -> void:
	var label := $Label3D
	var target_opacity := 0.0
	if Global.dialog_ended and player_in_range:
		target_opacity = 1.0

	var current_modulate = label.modulate
	current_modulate.a = lerp(current_modulate.a, target_opacity, fade_speed * delta)
	label.modulate = current_modulate
