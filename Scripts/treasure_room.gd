extends DefRoom
class_name TreasureRoom

var itemSelector = preload("res://Items/ItemCardSelector.tscn")
var blockedSpeed = 0
var speed

func _ready() -> void:
	instCardSelector()

func instCardSelector():
	var instCards = itemSelector
	instCards = itemSelector.instantiate()
	instCards.position = Vector2(292, 184)
	add_child(instCards)
