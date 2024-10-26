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

func _ready() -> void:
	$ItemTemplate.grab_focus()
	load_all_scene_paths()
	#get_item_card(Blue_scene_paths, BLUE_PATH)

func load_all_scene_paths():
	load_scene_paths(BLUE_PATH, Blue_scene_paths)
	load_scene_paths(WHITE_PATH, White_scene_paths)
	load_scene_paths(RED_PATH, Red_scene_paths)
	load_scene_paths(GREEN_PATH, Green_scene_paths)
	load_scene_paths(BLACK_PATH, Black_scene_paths)
	load_scene_paths(COLORLESS_PATH, Colorless_scene_paths)
	
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
	
func get_item_card(card_color: Array, Path: String) -> String:
	var item_index = randi_range(0, card_color[0].size() - 1)
	print(item_index)
	print(Path + card_color[0][item_index])  
	return Path + card_color[0][item_index]
	
	
#para maña hacer este metodo, poner un switch en el get itemcard para dar tmb el path y no liarme tanto y no tener que dar dos parametros en el item get card
func left_card_inst():
	pass
	#var card = get_item_card()
	
