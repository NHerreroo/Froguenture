class_name Run
extends Node


#NACHETE ACUERDATE QUE EST OEN UN FUTURO TE VA A PASAR OTRA VEEEE FIJATE QUE LA ROOM CUANDO SE CREE NO ESTE EL ERASE_LEVEL EN TRUE*** QUE SI NO 
#LA HABITACION SE BORRA TALCUAL ENTRAS

const BATTLE_SCENE := preload("res://Scenes/Main.tscn")
const CAMPFIRE_SCENE := preload("res://Scenes/Rooms/TreasureRooms/TreasureRoom.tscn")
const SHOP_SCENE := preload("res://Scenes/Rooms/Taverns/Tavern1.tscn")
const TREASURE_SCENE := preload("res://Scenes/Rooms/TreasureRooms/TreasureRoom.tscn")
const BOSS_SCENE := preload("res://Scenes/Rooms/TreasureRooms/TreasureRoom.tscn")

@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView

func _ready():
	_start_run()
	_setup_event_connections()
	map.connect("map_exited", Callable(self, "_on_map_exited"))
	Player.connect("do_transition", Callable(self, "do_transition"))

func _start_run():
	map.generate_new_map()
	map.unlock_floor(0)

func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	
	Global.rooms_visited.clear() # a la mierda las rooms visitadas
	Global.persistent_items.clear() # a la mierda los items del suelo

	Global.card_selected = false
	Global.treasure_card_selected = false
	Global.eraseLevel = false
	
	map.hide_map()

	return new_view

func _show_map():
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	map.show_map()
	map.unlock_next_room()
	
func _on_map_exited(room:Room) -> void:
	match  room.type:
		Room.Type.MONSTER:
			Global.specialRooms = false
			_change_view(BATTLE_SCENE)
		Room.Type.TREASURE:
			Global.specialRooms = true
			_change_view(TREASURE_SCENE)
		Room.Type.CAMPFIRE:
			Global.specialRooms = true
			_change_view(CAMPFIRE_SCENE)
		Room.Type.SHOP:
			Global.specialRooms = true
			_change_view(SHOP_SCENE)
		Room.Type.BOSS:
			_change_view(BOSS_SCENE)


func _setup_event_connections() -> void:
	Events.level_done.connect(_show_map)
	
	
var transition = preload("res://Scenes/Others/transition.tscn")
func do_transition():
	var inst_transition = transition.instantiate()
	add_child(inst_transition)
	move_child(inst_transition, 0)
