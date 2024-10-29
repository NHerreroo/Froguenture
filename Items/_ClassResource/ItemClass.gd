extends Button
class_name Item

@export var item_Src : Item_source #esto da el source para el menu de la izquierda

const WHITE_CARD = preload("res://Sprites/Items/Whitetemplate.png")
const BLACK_CARD = preload("res://Sprites/Items/Blacktemplate.png")
const RED_CARD = preload("res://Sprites/Items/Redtemplate.png")
const GREEN_CARD = preload("res://Sprites/Items/Greentemplate.png")
const BLUE_CARD = preload("res://Sprites/Items/Bluetemplate.png")
const COLORLESS = preload("res://Sprites/Items/Colorlesstemplate.png")

#COASA DEL SHADER DE LA CARTA
@export var angle_x_max: float = 15.0
@export var angle_y_max: float = 15.0
@export var max_offset_shadow: float = 50.0

@export_category("Oscillator")
@export var spring: float = 150.0
@export var damp: float = 10.0
@export var velocity_multiplier: float = 2.0

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var tween_rot: Tween
var tween_hover: Tween
var tween_destroy: Tween
var tween_handle: Tween

var last_mouse_pos: Vector2
var mouse_velocity: Vector2
var following_mouse: bool = false
var last_pos: Vector2
var velocity: Vector2


@onready var card_texture: TextureRect = $CardColor
@onready var shadow = $Shadow
@onready var collision_shape = $Area2D/CollisionShape2D

func _ready() -> void:
	entryCard()
	setSorurceParam()


func _on_focus_entered() -> void:
	_on_mouse_entered()
	
func _on_focus_exited() -> void:
	_on_mouse_exited()

func _on_mouse_entered() -> void:
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.2, 1.2), 0.5)

func _on_mouse_exited() -> void:
	# Reset rotation
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.5)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.5)
	

	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.55)
	
func _on_pressed():
	Global.can_walk = true
	print("sdf")


func setSorurceParam():
	setFoil()
		
	match item_Src.color_card:
		Item_source.color.WHITE:
			$CardColor.texture = WHITE_CARD
		Item_source.color.BLACK:
			$CardColor.texture = BLACK_CARD
		Item_source.color.BLUE:
			$CardColor.texture = BLUE_CARD
		Item_source.color.RED:
			$CardColor.texture = RED_CARD
		Item_source.color.GREEN:
			$CardColor.texture = GREEN_CARD
		Item_source.color.COLORLESS:
			$CardColor.texture = COLORLESS


	$CardColor/CardImage.texture = item_Src.image
	$CardColor/Name.text = item_Src.name
	$CardColor/Type.text = Item_source.Card_type.keys()[item_Src.card_type]
	$CardColor/Habilitie.text = item_Src.habilitie1 + "\n" + item_Src.habilitie2 + "\n" + item_Src.habilitie3
	$CardColor/Quote.text = item_Src.quote
	$CardColor/Damage.text = item_Src.damage
	$CardColor/Health.text = item_Src.health
	
func setFoil():
	var chance = randi_range(0,6)
	if chance <= 4:
		$CardColor/Foil2.visible = false
		$CardColor/Foil.visible = false
	else:
		$CardColor/Foil2.visible = true
		$CardColor/Foil.visible = true
		

func entryCard():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "modulate:a",0, 0)
	tween.tween_property(self, "modulate:a",1, 2.5)
