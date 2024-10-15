extends Node2D

# Número de pisos y nodos por piso
var floor_count = 5
var nodes_per_floor = 3
var node_size = Vector2(50, 50)

# Diccionario de tipos de nodos
var node_types = ['Battle', 'Shop', 'Event']

# Almacenará las posiciones de los nodos
var map = []

func _ready():
	generate_map()

# Genera el mapa con nodos y caminos entre ellos
func generate_map():
	randomize()  # Semilla aleatoria
	
	for i in range(floor_count):
		var floor = []
		
		# Generar nodos en cada piso
		for j in range(nodes_per_floor):
			var node_pos = Vector2(j * 150 + randf_range(-50, 50), i * 200)
			floor.append(node_pos)
			
			# Crear nodo visual
			var node_type = node_types[randi() % node_types.size()]
			create_node(node_pos, node_type)
		
		map.append(floor)
	
	# Conectar nodos entre pisos
	for i in range(floor_count - 1):
		for start_node in map[i]:
			var end_node = map[i + 1][randi() % nodes_per_floor]
			draw_line(start_node, end_node, Color(1, 1, 1), 2)

# Crear nodos como sprites o simples rectángulos
# Crear nodos como sprites o simples rectángulos
func create_node(pos: Vector2, node_type: String):
	var node = ColorRect.new()
	node.set_size(node_size)  # Ajustar el tamaño del ColorRect
	node.position = pos  # Colocar el nodo en la posición correcta
	
	# Asignación de color basada en el tipo de nodo
	if node_type == 'Battle':
		node.color = Color(1, 0, 0)  # Rojo para batallas
	elif node_type == 'Shop':
		node.color = Color(0, 1, 0)  # Verde para tiendas
	elif node_type == 'Event':
		node.color = Color(0, 0, 1)  # Azul para eventos
	
	add_child(node)

