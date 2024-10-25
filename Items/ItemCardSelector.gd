extends Control

var White_scene_paths: Array = []
var Black_scene_paths: Array = []
var Blue_scene_paths: Array = []
var Red_scene_paths: Array = []
var Green_scene_paths: Array = []
var Colorless_scene_paths: Array = []

func _ready() -> void:
	$ItemTemplate.grab_focus()
	load_all_scene_paths()

func load_all_scene_paths():
	load_scene_paths("res://Items/Blue/", Blue_scene_paths)
	load_scene_paths("res://Items/White/", White_scene_paths)
	load_scene_paths("res://Items/Red/", Red_scene_paths)
	load_scene_paths("res://Items/Green/", Green_scene_paths)
	load_scene_paths("res://Items/Black/", Black_scene_paths)
	load_scene_paths("res://Items/Colorless/", Colorless_scene_paths)
	
#mete las escenas en cada array de su color
func load_scene_paths(folder_path: String, ItemColorArray: Array) -> void:
	var dir = DirAccess.open(folder_path)
	ItemColorArray.append(dir.get_files())
	print(ItemColorArray) 
