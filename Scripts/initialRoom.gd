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


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("atack"):
		print("hoal")
