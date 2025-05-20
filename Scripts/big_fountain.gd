extends Node3D

func _ready() -> void:
	$Sprite3D2/Label3D.text = str(Global.totalSeeds)
