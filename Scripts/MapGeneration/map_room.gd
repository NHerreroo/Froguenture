extends Area2D
class_name MapRoom

signal selected(room:Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://Sprites/icons/skull.png"), Vector2(0.4, 0.4)],
	Room.Type.TREASURE: [preload("res://Sprites/icons/treasure.png"), Vector2(0.4, 0.4)],
	Room.Type.CAMPFIRE: [preload("res://Sprites/icons/campfire.png"), Vector2(0.4, 0.4)],
	Room.Type.SHOP: [preload("res://Sprites/icons/shoop.png"), Vector2(0.4, 0.4)],
	Room.Type.BOSS: [preload("res://Sprites/icons/boss.png"), Vector2(0.8, 0.8)],
}

@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var line_2d: Line2D = $Visuals/Line2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room: Room : set = set_room

var pointer_over := false  # Variable para detectar si el puntero está sobre el botón

func set_available(new_value: bool) -> void:
	available = new_value
	
	if available:
		animation_player.play("highlight")
	elif not room.selected:
		animation_player.play("RESET")
		
func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]


func show_selected():
	pass

func on_map_room_selected() -> void:
	selected.emit(room)

func _on_button_pressed():
	if not available or not $Visuals/Sprite2D/Button.pressed:
		return

	$AudioStreamPlayer.play()
	room.selected = true
	animation_player.play("select")

	
func emitTransition():
	Player.notifyTransition()
