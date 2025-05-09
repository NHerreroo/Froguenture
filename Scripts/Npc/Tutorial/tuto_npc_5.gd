extends npc

func _ready() -> void:
	$Sprite3D/Area3D/IteracArea.disabled = true
	await get_tree().create_timer(1).timeout
	instantiateDialog("res://Dialogs/Tutorial/Tutorial5.txt", default_pos)
	while true:
		await get_tree().create_timer(1).timeout
		if Global.enemies_remaining <= 0:
			instantiateDialog("res://Dialogs/Tutorial/Tutorial5-2.txt",default_pos)
			break
	while Global.dialog_ended == false:
		await get_tree().create_timer(1).timeout
	Global.resetall()
	get_tree().change_scene_to_file("res://Scenes/run.tscn")
	
	
