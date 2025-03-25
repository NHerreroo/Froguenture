extends DefRoom
class_name TreasureRoom

var itemSelector = preload("res://Items/ItemCardSelector.tscn")
var blockedSpeed = 0
var speed

func _ready() -> void:
	print(Global.actRoomChar)
		
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		if Global.treasure_card_selected == false:
			instCardSelector()

func instCardSelector():
	var instCards = itemSelector
	instCards = itemSelector.instantiate()
	instCards.position = Vector2(292, 184)
	add_child(instCards)
