extends Node3D

@export var fade_time := 0.3
var timer := 0.0
var start_modulate := Color(1, 1, 1, 1)

func _ready():
	for child in get_children():
		if child is AnimatedSprite3D:
			child.modulate = start_modulate

func _process(delta):
	timer += delta
	var alpha := 1.0 - (timer / fade_time)

	for child in get_children():
		if child is AnimatedSprite3D:
			child.modulate.a = clamp(alpha, 0, 1)

	if timer >= fade_time:
		queue_free()
