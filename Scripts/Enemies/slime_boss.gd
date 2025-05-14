extends Node3D

var altarSeed = preload("res://Scenes/SeedAltar.tscn")

# Variables para la vida del enemigo
var max_health: float = 1000.0  # Vida máxima del enemigo
var health_bar_max_width: float = 809.0  # Tamaño máximo de la barra en X
var health_bar: NinePatchRect


func _ready() -> void:
	# Obtener referencias
	health_bar = $NinePatchRect
	health_bar.size.x = health_bar_max_width  # Establecer tamaño inicial
	update_health_bar()

func _process(_delta: float) -> void:
	if Global.enemies_remaining == 0:
		$NinePatchRect.visible = false
		spawnSeed()
		Global.enemies_remaining = 1
		
	update_health_bar()  # Actualizar la barra en cada frame
	
# Función para actualizar la barra de vida
func update_health_bar() -> void:
	# Verificamos si el nodo existe antes de continuar
	if not is_instance_valid($EnemyTemplate):
		return
	
	var current_health: float = $EnemyTemplate.health
	var health_ratio: float = current_health / max_health
	health_bar.size.x = health_bar_max_width * health_ratio


func spawnSeed():
	var newAltar = altarSeed.instantiate()
	newAltar.position = Vector3(-2,0,0)
	add_child(newAltar)
