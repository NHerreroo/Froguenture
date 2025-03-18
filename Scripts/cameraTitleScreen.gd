extends Camera3D

const MAX_DISTANCE = 0.5  # Distancia máxima de movimiento
const FIXED_X = -11.387  # X fijo
const LERP_SPEED = 5.0  # Velocidad de interpolación

var center_pos = Vector3()  # Posición inicial de la cámara
var target_pos = Vector3()  # Posición objetivo

func _ready():
	center_pos = global_transform.origin
	center_pos.x = FIXED_X  # Asegurar que X siempre sea -9.056
	target_pos = center_pos  # Inicializar la posición objetivo

func _process(delta):
	self.current = true
	
	
	# Obtener dirección del mouse en el espacio de la pantalla
	var viewport_size = get_viewport().get_visible_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var normalized_mouse_pos = (mouse_pos / viewport_size) * 2.0 - Vector2(1.0, 1.0)  # Normalizar entre -1 y 1
	
	# Calcular posición objetivo
	var offset = Vector3(
		0,  # X siempre es -9.056
		-normalized_mouse_pos.y * MAX_DISTANCE,  # Invertir Y para que sea intuitivo
		normalized_mouse_pos.x * MAX_DISTANCE   # Usar X del mouse para mover en Z
	)
	target_pos = center_pos + offset
	target_pos.x = FIXED_X  # Mantener X fijo

	# Aplicar LERP para suavizar el movimiento
	global_transform.origin = global_transform.origin.lerp(target_pos, LERP_SPEED * delta)
