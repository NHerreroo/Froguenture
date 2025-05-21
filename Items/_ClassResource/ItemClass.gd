extends Button
class_name Item

@export var item_Src : Item_source #esto da el source para el menu de la izquierda

const WHITE_CARD = preload("res://Sprites/Items/Whitetemplate2.png")
const BLACK_CARD = preload("res://Sprites/Items/Blacktemplate2.png")
const RED_CARD = preload("res://Sprites/Items/Redtemplate2.png")
const GREEN_CARD = preload("res://Sprites/Items/GreenTemplate2.png")
const BLUE_CARD = preload("res://Sprites/Items/Bluetemplate2.png")
const COLORLESS = preload("res://Sprites/Items/ColorLessTemplate2.png")
const TAROT = preload("res://Sprites/Items/Tarot.png")
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

var selected = false
var animation_in_progress = false 

@onready var card_texture: TextureRect = $CardColor
@onready var shadow = $Shadow
@onready var collision_shape = $Area2D/CollisionShape2D

signal item_pressed


func _apply_passive():
	pass

#locura de sistema me cago en todo estoy volviendome loco
func _ready():
	self.scale = Vector2.ZERO
	self.modulate.a = 1.0
	
	if shadow:
		shadow.modulate.a = 0.5 
		shadow.position = Vector2(5, 5)  
	

	await get_tree().create_timer(0.1).timeout
	entryCard()

func _process(delta: float) -> void:
	if Global.card_selected == true and selected == false and not animation_in_progress:
		card_not_selected_animation()

func _on_focus_entered() -> void:
	_on_mouse_entered()
	
func _on_focus_exited() -> void:
	_on_mouse_exited()

func _on_mouse_entered() -> void:
	Events.notifycardHover()
	if Global.card_selected == false and selected == false and not animation_in_progress:
		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		
		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
		tween_hover.tween_property(self, "scale", Vector2(1.15, 1.15), 0.25) 
		tween_hover.tween_property(self, "rotation_degrees", 2.0, 0.25)
		
		if tween_rot and tween_rot.is_running():
			tween_rot.kill()
		tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
		tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 5.0, 0.25)
		tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 3.0, 0.25)
		
		if shadow:
			var shadow_tween = create_tween()
			shadow_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			shadow_tween.tween_property(shadow, "position", Vector2(8, 8), 0.25)
			shadow_tween.tween_property(shadow, "modulate:a", 0.6, 0.25)

func _on_mouse_exited() -> void:
	if Global.card_selected == false and selected == false and not animation_in_progress:
		if tween_rot and tween_rot.is_running():
			tween_rot.kill()
		tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE).set_parallel(true)
		tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.3)
		tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.3)

		if tween_hover and tween_hover.is_running():
			tween_hover.kill()
		

		tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
		tween_hover.tween_property(self, "scale", Vector2.ONE, 0.3)
		tween_hover.tween_property(self, "rotation_degrees", 0.0, 0.3)
		

		if shadow:
			var shadow_tween = create_tween()
			shadow_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			shadow_tween.tween_property(shadow, "position", Vector2(5, 5), 0.3)  
			shadow_tween.tween_property(shadow, "modulate:a", 0.5, 0.3)  

	
func _on_pressed():
	
	if Global.card_selected == false and selected == false and not animation_in_progress:
		Global.can_walk = true
		Global.card_selected = true
		selected = true
		animation_in_progress = true  
		
		disabled = true
		
		Player.CardsInDeck.append(self) #se mete en el deck del jogador caralho
		animate_to_player()
		emit_signal("item_pressed") 
		Events.notifycardSelect()

		await get_tree().create_timer(0.5).timeout
		
		Global.card_selected = false
		animation_in_progress = false
		

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
		Item_source.color.TAROT:
			$CardColor.texture = TAROT


	$CardColor/CardImage.texture = item_Src.image
	$CardColor/Name.text = item_Src.name
	if Item_source.color.TAROT:
		$CardColor/Type.visible = false
	$CardColor/Type.text = Item_source.Card_type.keys()[item_Src.card_type]
	$CardColor/Habilitie.text = item_Src.habilitie1 + "\n" + item_Src.habilitie2 + "\n" + item_Src.habilitie3
	$CardColor/Quote.text = item_Src.quote
	$CardColor/Damage.text = item_Src.damage
	$CardColor/Health.text = item_Src.health
	
func setFoil():
	var chance = randi_range(0,6)
	if chance <= 4:
		$CardColor/CardImage/Foil2.visible = false
		$CardColor/CardImage/Foil.visible = false
	else:
		$CardColor/CardImage/Foil2.visible = true
		$CardColor/CardImage/Foil.visible = true
		

func entryCard():
	animation_in_progress = true
	
	self.scale = Vector2.ZERO
	self.rotation_degrees = -15.0

	var entry_tween = create_tween()
	entry_tween.set_trans(Tween.TRANS_BACK)
	entry_tween.set_ease(Tween.EASE_OUT)
	entry_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	
	await entry_tween.finished
	
	var settle_tween = create_tween().set_parallel(true)
	settle_tween.set_trans(Tween.TRANS_ELASTIC)
	settle_tween.set_ease(Tween.EASE_OUT)
	settle_tween.tween_property(self, "scale", Vector2.ONE, 0.4)
	settle_tween.tween_property(self, "rotation_degrees", 0.0, 0.5)

	if shadow:
		var shadow_bounce_tween = create_tween()
		shadow_bounce_tween.set_trans(Tween.TRANS_BOUNCE)
		shadow_bounce_tween.set_ease(Tween.EASE_OUT)
		shadow_bounce_tween.tween_property(shadow, "position:y", shadow.position.y + 5, 0.2)
		shadow_bounce_tween.tween_property(shadow, "position:y", shadow.position.y, 0.3)
		shadow_bounce_tween.tween_property(shadow, "modulate:a", 0.3, 0.2)
		shadow_bounce_tween.tween_property(shadow, "modulate:a", 0.5, 0.3)
	
	await settle_tween.finished
	animation_in_progress = false

func animate_to_player():
	animation_in_progress = true 
	
	# Smooth selection animation
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "position:y", position.y - 30, 0.2)
	tween.tween_property(self, "rotation_degrees", 5, 0.2)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	
	if shadow:
		tween.tween_property(shadow, "position:y", shadow.position.y + 10, 0.2)
		tween.tween_property(shadow, "modulate:a", 0.3, 0.2)
	
	tween.chain().tween_callback(func():
		var move_tween = create_tween().set_parallel(true)
		move_tween.set_trans(Tween.TRANS_QUINT)
		move_tween.set_ease(Tween.EASE_IN)
		move_tween.tween_property(self, "position", Vector2(750, 150), 0.4)
		move_tween.tween_property(self, "scale", Vector2(0, 0), 0.4)
		move_tween.tween_property(self, "rotation_degrees", 180, 0.4)
		move_tween.tween_property(self, "modulate:a", 0, 0.3)
		
		if shadow:
			move_tween.tween_property(shadow, "position", Vector2(755, 155), 0.4)
			move_tween.tween_property(shadow, "modulate:a", 0, 0.3)
	).set_delay(0.1)
	
func card_not_selected_animation():
	animation_in_progress = true

	disabled = true
	
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	
	var rotation_amount = 45 if randf() > 0.5 else -45
	
	tween.tween_property(self, "rotation_degrees", rotation_amount, 0.4)
	tween.tween_property(self, "position:y", position.y + 100, 0.5)
	tween.tween_property(self, "modulate:a", 0, 0.4)
	tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.4)
	
	if shadow:
		tween.tween_property(shadow, "rotation_degrees", rotation_amount, 0.4).set_delay(0.05)
		tween.tween_property(shadow, "position:y", shadow.position.y + 110, 0.5).set_delay(0.05)
		tween.tween_property(shadow, "modulate:a", 0, 0.4)
	
	await tween.finished
	animation_in_progress = false  # Clear animation flag
