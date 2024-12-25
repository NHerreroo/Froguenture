extends Node3D

var player = null
var collilsions_seted = false

var sides = ["top", "bot", "right", "left"]

func _ready():
	player = get_tree().get_root().find_child("player", true, false)

func _process(delta):
	if Global.enemies_remaining == 0:
		setCollisions()
	else:
		activateAllCollisions()
	
	if Global.eraseLevel == true:
		queue_free()

func setCollisions():
	for side in sides:
		var collider = $BoundsColliders/StaticBody3D.get_node(side + "btwn")
		collider.disabled = not Global.get(side + "Collider")
	collilsions_seted = true


func activateAllCollisions():
	for side in sides:
		var collider = $BoundsColliders/StaticBody3D.get_node(side + "btwn")
		collider.disabled = false
	collilsions_seted = false  
