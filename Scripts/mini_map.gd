extends Control

# Texturas para las salas


var texture_first_room = preload("res://Sprites/icons/minimap_def_room.png")
var texture_room = preload("res://Sprites/icons/minimap_def_room.png")
var texture_boss = preload("res://Sprites/icons/minimap_def_room.png")
var texture_treasure = preload("res://Sprites/icons/minimap_def_room.png")
var texture_shop = preload("res://Sprites/icons/minimap_def_room.png")
var texture_empty: Texture2D  # Opcional, para salas no exploradas

# Tamaño del minimapa
@export var room_size = Vector2(32, 32)  # Tamaño de cada sala en el minimapa
@export var visible_radius = 1  # Rango de salas visibles alrededor del jugador
@export var room_margin = 55

# Referencia al mapa principal
var map = []
var player_position = Vector2() 

var minimap_sprites = {}

func _ready():
	map = Global.map
	player_position = Vector2(Global.playerMapPositionX, Global.playerMapPositionY)
	draw_minimap()

func draw_minimap():
	for sprite in minimap_sprites.values():
		sprite.queue_free()
	minimap_sprites.clear()

	for x_offset in range(-visible_radius, visible_radius + 1):
		for y_offset in range(-visible_radius, visible_radius + 1):
			var room_x = player_position.x + x_offset
			var room_y = player_position.y + y_offset

			if room_x >= 0 and room_x < map.size() and room_y >= 0 and room_y < map[room_x].size():
				var room_type = map[room_x][room_y]
				if room_type != ' ':
					add_minimap_sprite(Vector2(room_x, room_y), room_type)

func add_minimap_sprite(position: Vector2, room_type: String):

	var sprite = TextureRect.new()
	sprite.texture = get_room_texture(room_type)
	sprite.size = room_size


	var offset = room_size + Vector2(room_margin, room_margin)
	sprite.position = (position - player_position) * offset + (size / 2) - (room_size / 2)  # Centrar en el minimapa
	add_child(sprite)

	minimap_sprites[position] = sprite

func get_room_texture(room_type: String) -> Texture2D:
	match room_type:
		'@':
			return texture_first_room
		'1':
			return texture_room
		'2':
			return texture_room
		'X':
			return texture_boss
		'#':
			return texture_treasure
		'$':
			return texture_shop
		_:
			return texture_empty  # Opcional

func update_minimap(new_position: Vector2):
	player_position = new_position
	draw_minimap()
