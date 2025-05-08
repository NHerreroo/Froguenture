extends Node3D

var player_in_range = false

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
		$Sprite3D/TextBoxSystem.start_dialog("res://Dialogs/Tutorial1.txt")
		Global.dialog_ended = false
		get_viewport().set_input_as_handled()
		
func _process(delta: float) -> void:
	if Global.dialog_ended and player_in_range:
		$Label3D.visible = true
	else:
		$Label3D.visible = false
