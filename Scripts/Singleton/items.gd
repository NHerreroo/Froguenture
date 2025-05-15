extends Node

# Salud
func increase_health(amount: float) -> void:
	Player.health = min(Player.health + amount, Player.health)
	Player.notify_health_updated()

func decrease_health(amount: float) -> void:
	Player.health = max(0.0, Player.health - amount)
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
	Player.shield = max(0.0, Player.shield - amount)

# Dinero
func increase_money(amount: int) -> void:
	Player.money += amount

func decrease_money(amount: int) -> void:
	Player.money = max(0, Player.money - amount)


func increase_baseAtack(amount: float) -> void:
	Player.baseattack += amount

func decrease_baseAtack(amount: float) -> void:
	Player.baseattack = max(0, Player.baseattack - amount)
	
# Multiplicador de ataque
func increase_attack_multiplier(amount: float) -> void:
	Player.attackMultiplier += amount

func decrease_attack_multiplier(amount: float) -> void:
	Player.attackMultiplier = max(0.0, Player.attackMultiplier - amount)

# Velocidad
func increase_speed(amount: float) -> void:
	Player.speed += amount

func decrease_speed(amount: float) -> void:
	Player.speed = max(0.1, Player.speed - amount)

# Crítico
func increase_critical(amount: float) -> void:
	Player.criticalDamage += amount

func decrease_critical(amount: float) -> void:
	Player.criticalDamage = max(0.0, Player.criticalDamage - amount)

# Veneno
func increase_poison(amount: float) -> void:
	Player.poisonDamage += amount

func decrease_poison(amount: float) -> void:
	Player.poisonDamage = max(0.0, Player.poisonDamage - amount)

# Velocidad de ataque
func increase_attack_speed(amount: float) -> void:
	Player.atackSpeed += amount

func decrease_attack_speed(amount: float) -> void:
	Player.atackSpeed = max(0.01, Player.atackSpeed - amount)

# Dash cooldown
func decrease_dash_cooldown(amount: float) -> void:
	Player.dashCooldown = max(0.1, Player.dashCooldown - amount)

func increase_dash_cooldown(amount: float) -> void:
	Player.dashCooldown += amount
