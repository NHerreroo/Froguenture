extends Enemy

func _process(delta: float) -> void:
	enem_area_disabled()
	if Global.debilited == true:
		$Sprites.visible = true
	if Global.debilited == false:
		$Sprites.visible = false
