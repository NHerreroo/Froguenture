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

var card_instance1
var card_instance2

func _ready() -> void:
	Global.can_walk = false
	set_background_opacity_in()
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


# Mete las escenas en cada array de su color
func load_scene_paths(folder_path: String, ItemColorArray: Array) -> void:
	var dir = DirAccess.open(folder_path)
	ItemColorArray.append(dir.get_files())

func get_random_color() -> Array:
	var num = randi_range(0,5)
	match num:
		0: return White_scene_paths
		1: return Black_scene_paths
		2: return Blue_scene_paths
		3: return Green_scene_paths
		4: return Red_scene_paths
		5: return Colorless_scene_paths
		_: return Colorless_scene_paths

func get_item_card(card_color: Array) -> String:
	var item_index = randi_range(0, card_color[0].size() - 1)
	var path

	match card_color:
		White_scene_paths: path = WHITE_PATH
		Black_scene_paths: path = BLACK_PATH
		Green_scene_paths: path = GREEN_PATH
		Blue_scene_paths: path = BLUE_PATH
		Red_scene_paths: path = RED_PATH
		Colorless_scene_paths: path = COLORLESS_PATH

	return path + card_color[0][item_index]

func left_card_inst(card_path: String):
	var card = load(card_path)
	card_instance1 = card.instantiate()
	card_instance1.position = Vector2(292, 184)
	add_child(card_instance1)

	if card_instance1 is Button:
		card_instance1.grab_focus()

func right_card_inst(card_path: String):
	var card = load(card_path)
	card_instance2 = card.instantiate()
	card_instance2.position = Vector2(1110, 191)
	add_child(card_instance2)

func grab_focus_after_pause():
	if Global.is_game_paused == false and Global.card_focused == false:
		await get_tree().create_timer(0.1).timeout
		card_instance1.grab_focus()
		Global.card_focused = true

func _process(delta: float) -> void:
	grab_focus_after_pause()
	if Global.card_selected:
		set_background_opacity_out()
		await get_tree().create_timer(3).timeout
		queue_free()


func set_background_opacity_in():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($BlackBg, "color:a", 0.85, 2)


func set_background_opacity_out():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($BlackBg, "color:a", -10, 2)
	tween.tween_property($BlurShader.material, "shader_parameter/lod", -30, 1)
	
