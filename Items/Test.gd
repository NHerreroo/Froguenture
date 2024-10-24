extends Node2D
class_name Item

@export var item_Src : Item_source

var WhiteCard = preload("res://Sprites/Items/Whitetemplate.png")

func setSorurceParam():
	match Item_source.color:
		Item_source.color.WHITE:
			$CardColor.texture = WhiteCard
