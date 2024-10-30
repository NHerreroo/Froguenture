extends Node3D

var player = null
var collilsions_seted = false

func _ready():
	
	player = get_tree().get_root().find_child("player", true, false)

func _process(delta):
	if collilsions_seted == false:
		setCollisions()
	if Global.eraseLevel == true:
		queue_free()


#activa o desactiva las collsiones que van en la zona de las puertas siempre y cuando no haya una puerta AAJAJ (me estoy empezando a volver loco)
func setCollisions():
	var sides = ["top", "bot", "right", "left"]
	for side in sides:
		var collider = $BoundsColliders/StaticBody3D.get_node(side + "btwn")
		collider.disabled = not Global.get(side + "Collider")
	collilsions_seted = true
