extends Node


# STATS
var money : int = 100
var health : float = 3.5
var health_container : int = 5
var shield : float = 0.5

var atack : float = 3.0
var speed : float= 5.0
var criticalDamage : float = 0.0
var poisonDamage : float = 0.0
var atackSpeed : float = 0.2  #0.6
var dashCooldown : float = 1.0

var damageToRecive = 0.5 #el daño que te hacen los enemigos 1 es corazon enetero 0.5 medio
var invencibleTime = 1


#noificador de vida actualizada (general)
signal health_updated
func notify_health_updated():
	emit_signal("health_updated")
