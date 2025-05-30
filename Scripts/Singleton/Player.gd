extends Node

# STATS
var money : int = 10
var health : float = 15
var health_container : int = 3
var shield : float = 0

var baseattack : float = 3
var attackMultiplier : float = 1
var atack : float = 2

var speed : float= 5.0
var criticalDamage : float = 0.0
var poisonDamage : float = 0.0
var atackSpeed : float = 0.3  #0.6
var dashCooldown : float = 1.0

var damageToRecive = 0.5 #el daño que te hacen los enemigos 1 es corazon enetero 0.5 medio
var invencibleTime = 1
var is_dashing = false

var havePosionDash = false
var haveCounterspell = false

var is_dead = false

var CardsInDeck = []
#noificador de vida actualizada (general)
signal health_updated


func notify_health_updated():
	emit_signal("health_updated")


signal do_transition
func notifyTransition():
	emit_signal("do_transition")


var total
func _process(delta: float) -> void:
	atack = baseattack * attackMultiplier
	
	if atackSpeed <= 0:
		atackSpeed = 0
			
	#limitar contenedores 
	if health_container >= 12:
		health_container = 12

	#limitar vida
	if health >= health_container:
		health = health_container

	#limitar escudos
	total = health_container + shield
	if total > 12:
		shield -= (total - 12) # Ajustar escudo si el total excede 12
		
	
func setBaseStats():
	ApplyItems.pasiveItems.clear()
	money = 15
	health = 3
	health_container = 3
	shield = 0

	baseattack = 3
	attackMultiplier = 1
	atack = 2

	speed = 5.0
	criticalDamage = 0.0
	poisonDamage = 0.0
	atackSpeed = 0.3#0.6
	dashCooldown = 2

	damageToRecive = 0.5 #el daño que te hacen los enemigos 1 es corazon enetero 0.5 medio
	invencibleTime = 1
	is_dashing = false
	havePosionDash = false
	haveCounterspell = false
	
	is_dead = false
	CardsInDeck = []
