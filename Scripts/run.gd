class_name Run
extends Node

const BATTLE_SCENE := preload("res://Scenes/Main.tscn")
const CAMPFIRE_SCENE := preload("res://Scenes/Main.tscn")
const SHOP_SCENE := preload("res://Scenes/Main.tscn")
const TREASURE_SCENE := preload("res://Scenes/Main.tscn")
const BOSS_SCENE := preload("res://Scenes/Main.tscn")

@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView

func _ready():
	_start_run()
	_setup_event_connections()
	map.connect("map_exited", Callable(self, "_on_map_exited"))

	
func _start_run():
	map.generate_new_map()
	map.unlock_floor(0)

func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
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
			_change_view(BATTLE_SCENE)
		Room.Type.TREASURE:
			_change_view(TREASURE_SCENE)
		Room.Type.CAMPFIRE:
			_change_view(CAMPFIRE_SCENE)
		Room.Type.SHOP:
			_change_view(SHOP_SCENE)
		Room.Type.BOSS:
			_change_view(BOSS_SCENE)


func _setup_event_connections() -> void:
	Events.level_done.connect(_show_map)
