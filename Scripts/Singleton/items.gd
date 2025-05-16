extends Node

# Salud
func increase_health(amount: float) -> void:
	Player.health = Player.health + amount
	Player.notify_health_updated()

func decrease_health(amount: float) -> void:
	Player.health = Player.health - amount
	Player.notify_health_updated()

func increase_Maxhealth(amount: float) -> void:
	Player.health_container += amount
	Player.notify_health_updated()

func decrease_Maxhealth(amount: float) -> void:
	Player.health_container -= amount
	Player.notify_health_updated()

# Escudo
func increase_shield(amount: float) -> void:
	Player.shield += amount
	# Límite de escudos si es necesario
	var total = Player.health_container + Player.shield
	if total > 12:
		Player.shield -= (total - 12)

func decrease_shield(amount: float) -> void:
	Player.shield = Player.shield - amount

# Dinero
func increase_money(amount: int) -> void:
	Player.money += amount

func decrease_money(amount: int) -> void:
	Player.money = Player.money - amount


func increase_baseAtack(amount: float) -> void:
	Player.baseattack += amount

func decrease_baseAtack(amount: float) -> void:
	Player.baseattack = Player.baseattack - amount
	
# Multiplicador de ataque
func increase_attack_multiplier(amount: float) -> void:
	Player.attackMultiplier += amount

func decrease_attack_multiplier(amount: float) -> void:
	Player.attackMultiplier = Player.attackMultiplier - amount

# Velocidad
func increase_speed(amount: float) -> void:
	Player.speed += amount

func decrease_speed(amount: float) -> void:
	Player.speed = Player.speed - amount
	
# Crítico
func increase_critical(amount: float) -> void:
	Player.criticalDamage += amount

func decrease_critical(amount: float) -> void:
	Player.criticalDamage = Player.criticalDamage - amount

# Veneno
func increase_poison(amount: float) -> void:
	Player.poisonDamage += amount

func decrease_poison(amount: float) -> void:
	Player.poisonDamage = Player.poisonDamage - amount

# Velocidad de ataque
func increase_attack_speed(amount: float) -> void:
	Player.atackSpeed += amount

func decrease_attack_speed(amount: float) -> void:
	Player.atackSpeed = Player.atackSpeed - amount
	
# Dash cooldown
func decrease_dash_cooldown(amount: float) -> void:
	Player.dashCooldown = Player.dashCooldown - amount

func increase_dash_cooldown(amount: float) -> void:
	Player.dashCooldown += amount


func decrease_damageToRecive(amount: float) -> void:
	Player.damageToRecive -= Player.damageToRecive

func increase_damageToRecive(amount: float) -> void:
	Player.damageToRecive += Player.damageToRecive
	

#ITEMS PASIVOS 
var pasiveItems : Array = []

var is_the_one_sword_active = false
func TheOneSword():
	if Player.health <= 1.0:
		if not is_the_one_sword_active:
			increase_baseAtack(10)
			is_the_one_sword_active = true
	else:
		if is_the_one_sword_active:
			increase_baseAtack(-10)
			is_the_one_sword_active = false


var ancientSeed_Previous := 0
var ancientSeed_Current := 0

func AncientSeed():
	ancientSeed_Current = Global.lvlCount
	if ancientSeed_Current != ancientSeed_Previous:
		Player.health += 1.0
		Player.notify_health_updated()
		ancientSeed_Previous = ancientSeed_Current


var hunters_mark_active_bonus := 0
func huntersMark():
	var current_bonus = Global.enemies_remaining
	if current_bonus != hunters_mark_active_bonus:
		var difference = current_bonus - hunters_mark_active_bonus
		increase_baseAtack(difference)
		hunters_mark_active_bonus = current_bonus

func _process(delta: float) -> void:
	for func_name in pasiveItems:
		if has_method(func_name):
			call(func_name)
