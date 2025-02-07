extends TextureRect

var full_texture = preload("res://Sprites/icons/heart.png")
var half_texture = preload("res://Sprites/icons/halfHeart.png")
var empty_texture = preload("res://Sprites/icons/heartContainer.png")

func set_full():
	texture = full_texture

func set_half():
	texture = half_texture

func set_empty():
	texture = empty_texture
