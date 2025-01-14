extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HudLabels/Attack.text = str(Player.speed / 10)
	$HudLabels/DashCooldown.text = str(Player.dashCooldown / 10)
	$HudLabels/Poison.text = str(Player.poisonDamage / 10)
	$HudLabels/Speed.text = str(Player.speed / 10)
	$HudLabels/SpeedAttack.text = str(Player.atackSpeed / 10)
	
	
	$HudLabels/VIDAS.text = str(Player.healt)
	$HudLabels/MONEDAS.text = str(Player.money)
