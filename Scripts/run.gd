class_name Run
extends Node


#NACHETE ACUERDATE QUE EST OEN UN FUTURO TE VA A PASAR OTRA VEEEE FIJATE QUE LA ROOM CUANDO SE CREE NO ESTE EL ERASE_LEVEL EN TRUE*** QUE SI NO 
#LA HABITACION SE BORRA TALCUAL ENTRAS

const BATTLE_SCENE := preload("res://Scenes/Main.tscn")
const CAMPFIRE_SCENE := preload("res://Scenes/Rooms/TreasureRooms/TreasureRoom.tscn")
const SHOP_SCENE := preload("res://Scenes/Rooms/Taverns/Tavern1.tscn")
const TREASURE_SCENE := preload("res://Scenes/Rooms/TreasureRooms/TreasureRoom.tscn")
var BOSS_SCENE := preload("res://Scenes/Rooms/TreasureRooms/TreasureRoom.tscn")

var BOSSES = [
	"res://Scenes/Rooms/BossRooms/BossOwl.tscn",
	"res://Scenes/Rooms/BossRooms/slimeBoss.tscn"
	]


@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView

#cronometro run
var run_time = 0.0
var is_timer_running = false

# Función para iniciar el cronómetro
func start_timer():
	run_time = 0.0
	is_timer_running = true
	print("Cronómetro iniciado")


func _process(delta):
	if Global.runEnded == true:
		queue_free()
	if is_timer_running:
		run_time += delta
		Global.run_time = run_time


func _ready():
	_start_run()
	_setup_event_connections()
	map.connect("map_exited", Callable(self, "_on_map_exited"))
	Player.connect("do_transition", Callable(self, "do_transition"))

	if Global.is_in_tutorial == true:
		var tutorial_room := Room.new()
		tutorial_room.type = Room.Type.MONSTER 
		_on_map_exited(tutorial_room)
		
func _start_run():
	start_timer()
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
	Global.eraseLevel = false
		
	Global.treasureItem = null
	Global.treasureItemPurchased = false
	map.hide_map()

	return new_view


func _show_map():
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		
	map.show_map()
	map.unlock_next_room()
	
func _on_map_exited(room:Room) -> void:
	_choose_random_boss_room()	
	if Global.is_in_tutorial == true:
		match  room.type:
				Room.Type.MONSTER:
					Global.specialRooms = false
					_change_view(BATTLE_SCENE)
					
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

func _choose_random_boss_room():
	if Global.is_in_tutorial:
		BOSS_SCENE = preload("res://Scenes/Rooms/BossRooms/slimeBoss.tscn")
	else:
		var index = randi_range(0, BOSSES.size() - 1)
		var boss_path = BOSSES[index]
		BOSS_SCENE = load(boss_path)
