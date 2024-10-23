extends Node2D

@export var item_Src : Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = item_Src.image 
