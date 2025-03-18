extends Control

func _ready() -> void:
	Global.can_walk = false
	$AnimationPlayer.play("in")
	await $AnimationPlayer.animation_finished  # Espera la animación
	Global.can_walk = true
	queue_free()
