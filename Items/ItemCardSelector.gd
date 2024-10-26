extends Control

var White_scene_paths: Array
var Black_scene_paths: Array
var Blue_scene_paths: Array
var Red_scene_paths: Array
var Green_scene_paths: Array
var Colorless_scene_paths: Array

const BLUE_PATH = "res://Items/Blue/"
const WHITE_PATH = "res://Items/White/"
const RED_PATH = "res://Items/Red/"
const GREEN_PATH = "res://Items/Green/"
const BLACK_PATH = "res://Items/Black/"
const COLORLESS_PATH = "res://Items/Colorless/"

var card

func _ready() -> void:
	load_all_scene_paths()
	left_card_inst(get_item_card(get_random_color()))
	right_card_inst(get_item_card(get_random_color()))
	

func load_all_scene_paths():
	load_scene_paths(BLUE_PATH, Blue_scene_paths)
	load_scene_paths(WHITE_PATH, White_scene_paths)
	load_scene_paths(RED_PATH, Red_scene_paths)
	load_scene_paths(GREEN_PATH, Green_scene_paths)
	load_scene_paths(BLACK_PATH, Black_scene_paths)
	load_scene_paths(COLORLESS_PATH, Colorless_scene_paths)
	
	get_item_card(Blue_scene_paths)
	
#mete las escenas en cada array de su color
func load_scene_paths(folder_path: String, ItemColorArray: Array) -> void:
	var dir = DirAccess.open(folder_path)
	ItemColorArray.append(dir.get_files())
	print(ItemColorArray)
	
	
func get_random_color() -> Array:
	var num = randi_range(0,5)
	match num:
		0: #white
			return White_scene_paths
		1: #black
			return Black_scene_paths
		2: #blue
			return Blue_scene_paths
		3: #green
			return Green_scene_paths
		4: #red
			return Red_scene_paths
		5: #colorles
			return Colorless_scene_paths
		_:
			return Colorless_scene_paths
	
func get_item_card(card_color: Array) -> String:
	var item_index = randi_range(0, card_color[0].size() - 1)
	var path
	
	match card_color:
		White_scene_paths:
			path = WHITE_PATH
		Black_scene_paths:
			path = BLACK_PATH
		Green_scene_paths:
			path = GREEN_PATH
		Blue_scene_paths:
			path = BLUE_PATH
		Red_scene_paths:
			path = RED_PATH
		Colorless_scene_paths:
			path = COLORLESS_PATH
			
	return path + card_color[0][item_index]

func left_card_inst(card_path: String):
	var card = load(card_path)
	var card_instance = card.instantiate()
	card_instance.position = Vector2(292, 184)
	add_child(card_instance)
	
	if card_instance is Button:
		card_instance.grab_focus()
		
func right_card_inst(card_path: String):
	var card = load(card_path)
	var card_instance = card.instantiate()
	card_instance.position = Vector2(1110, 191)
	add_child(card_instance)
