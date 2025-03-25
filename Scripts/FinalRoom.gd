extends Node3D

var player = null


func _ready():
	setCollisions()
	player = get_tree().get_root().find_child("player", true, false)

func _process(delta):
	if Global.eraseLevel == true:
		queue_free()


#activa o desactiva las collsiones que van en la zona de las puertas siempre y cuando no haya una puerta AAJAJ (me estoy empezando a volver loco)
func setCollisions():
	var sides = ["top", "bot", "right", "left"]
	for side in sides:
		var collider = $BoundsColliders/StaticBody3D.get_node(side + "btwn")
		collider.disabled = not Global.get(side + "Collider")


func _on_button_pressed():
	reset_globals_set_def_stats()
	Events.emit_signal("level_done")
	
func reset_globals_set_def_stats():
	Global.isMapGenerated = false
	Global.playerMapPositionX = 25
	Global.playerMapPositionY = 25
	Global.eraseLevel = true
	Global.playerDirection = 4;
	Global.topCollider = false
	Global.botCollider = false
	Global.rightCollider = false
	Global.leftCollider = false
	Global.shopItem1 = null
	Global.shopItem2 = null
	Global.shopItem1Purchased = false
	Global.shopItem2Purchased = false
	Global.treasureItem = null
	Global.treasureItemPurchased = false
