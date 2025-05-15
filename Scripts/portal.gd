extends Node3D

var modalNewRun = preload("res://Scenes/startRunModal.tscn")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		spawnModal()
		Global.can_walk = false
		
func spawnModal():
	var newModal = modalNewRun.instantiate()
	add_child(newModal)
