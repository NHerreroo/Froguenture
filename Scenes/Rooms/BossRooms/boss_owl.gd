extends Node3D

# Variables para la vida del enemigo
var max_health: float = 800.0  # Vida máxima del enemigo
var health_bar_max_width: float = 809.0  # Tamaño máximo de la barra en X

# Referencia al NinePatchRect
var health_bar: NinePatchRect
var animation_player: AnimationPlayer
var last_debilited_state: bool = false

func _ready() -> void:
	# Obtener referencias
	health_bar = $NinePatchRect
	animation_player = $AnimationPlayer
	
	health_bar.size.x = health_bar_max_width  # Establecer tamaño inicial
	
	# Guardar el estado inicial
	last_debilited_state = Global.debilited
	
	# Actualizar la barra basada en la vida inicial
	update_health_bar()

func _process(_delta: float) -> void:
	update_health_bar()  # Actualizar la barra en cada frame
	
	# Detectar cambios en Global.debilited
	if Global.debilited != last_debilited_state:
		# Reproducir la animación correspondiente
		if Global.debilited:
			animation_player.play("flash")  # Animación para cuando se debilita
		else:
			animation_player.play("flash")    # Animación para cuando se recupera
		
		# Actualizar el último estado conocido
		last_debilited_state = Global.debilited

# Función para actualizar la barra de vida
func update_health_bar() -> void:
	var current_health: float = $EnemyTemplate2.health
	var health_ratio: float = current_health / max_health
	health_bar.size.x = health_bar_max_width * health_ratio
