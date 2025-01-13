extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$VIDAS.text = str(Global.healt)
	$MONEDAS.text = str(Global.money)
