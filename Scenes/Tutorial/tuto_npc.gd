extends npc

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	$Sprite3D/TextBoxSystem.start_dialog("res://Dialogs/Tutorial1.txt")
