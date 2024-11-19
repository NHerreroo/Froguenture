extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite3D1.play("default")
	$Sprite3D2.play("default")
	$Sprite3D3.play("default")
	$Sprite3D4.play("default")
	$Sprite3D5.play("default")
	$Sprite3D6.play("default")
	
func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("attack"):
		$Sprite3D1.play("cut")
		$Sprite3D2.play("cut")
		$Sprite3D3.play("cut")
		$Sprite3D4.play("cut")
		$Sprite3D5.play("cut")
		$Sprite3D6.play("cut")
