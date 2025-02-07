extends TextureRect

var full_texture = preload("res://Sprites/icons/shield.png")
var half_texture = preload("res://Sprites/icons/halfShield.png")

func set_full():
	texture = full_texture

func set_half():
	texture = half_texture
