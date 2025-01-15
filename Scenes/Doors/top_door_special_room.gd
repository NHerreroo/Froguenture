extends Area3D

func _ready() -> void:
	$Trunk.visible = false
	
func _process(delta):
	if Global.eraseLevel == true:
		Events.emit_signal("level_done")
		queue_free()
		
func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.eraseLevel = true
