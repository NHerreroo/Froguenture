extends npc

func _ready() -> void:
	dialogs = [ "res://Dialogs/Tutorial/Tutorial2-1.txt",
				"res://Dialogs/Tutorial/Tutorial2-2.txt"]
				
	await get_tree().create_timer(1).timeout
	instantiateDialog("res://Dialogs/Tutorial/Tutorial2.txt", default_pos)
