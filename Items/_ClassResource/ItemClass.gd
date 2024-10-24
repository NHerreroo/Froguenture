extends Node2D
class_name Item

@export var item_Src : Item_source

const WHITE_CARD = preload("res://Sprites/Items/Whitetemplate.png")
const BLACK_CARD = preload("res://Sprites/Items/Blacktemplate.png")
const RED_CARD = preload("res://Sprites/Items/Redtemplate.png")
const GREEN_CARD = preload("res://Sprites/Items/Greentemplate.png")
const BLUE_CARD = preload("res://Sprites/Items/Bluetemplate.png")
const COLORLESS = preload("res://Sprites/Items/Colorlesstemplate.png")

func _ready() -> void:
	setSorurceParam()

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


	$CardImage.texture = item_Src.image
	$Name.text = item_Src.name
	$Type.text = Item_source.Card_type.keys()[item_Src.card_type]
	$Habilitie.text = item_Src.habilitie1 + "\n" + item_Src.habilitie2 + "\n" + item_Src.habilitie3
	$Quote.text = item_Src.quote
	$Damage.text = item_Src.damage
	$Health.text = item_Src.health
	
func setFoil():
	var chance = randi_range(0,6)
	print(chance)
	if chance <= 5:
		$Foil2.visible = false
		$Foil.visible = false
	else:
		$Foil2.visible = true
		$Foil.visible = true
	
