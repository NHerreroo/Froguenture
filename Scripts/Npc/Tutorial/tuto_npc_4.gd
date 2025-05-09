extends npc

func _ready() -> void:
	$Sprite3D/Area3D/IteracArea.disabled = true
	await get_tree().create_timer(1).timeout
	instantiateDialog("res://Dialogs/Tutorial/Tutorial4.txt", default_pos)
