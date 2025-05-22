extends Node3D

const SPEED := 5.0 

func _ready() -> void:
	$AnimationPlayer.play("walk")

func _process(delta: float) -> void:
	position.z += SPEED * delta
