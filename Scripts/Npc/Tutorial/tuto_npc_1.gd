extends npc


func _ready() -> void:
	$AnimationPlayer.play("idle")
	dialogs = [ "res://Dialogs/Tutorial/Tutorial1-1.txt",
				"res://Dialogs/Tutorial/Tutorial1-2.txt",
				"res://Dialogs/Tutorial/Tutorial1-3.txt",
				"res://Dialogs/Tutorial/Tutorial1-4.txt"]
				
	await get_tree().create_timer(1).timeout
	instantiateDialog("res://Dialogs/Tutorial/Tutorial1.txt", default_pos)
