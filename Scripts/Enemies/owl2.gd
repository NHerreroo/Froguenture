extends Enemy

var debilited_time: float = 0.0
var sprite_delay_timer: float = 0.0
var should_show_sprites: bool = false

func _ready() -> void:
	Global.enemies_remaining += 1
	enem_area_disabled()
	$Sprites.visible = false
	
func _process(delta: float) -> void:
	enem_area_disabled()
	canReciveDamage = false
	
	if Global.debilited:
		canReciveDamage = true
		debilited_time += delta
		if debilited_time >= 10.0:
			Global.debilited = false
			debilited_time = 0.0
	else:
		debilited_time = 0.0
	# Retraso de 0.7s para mostrar/ocultar sprites
	if should_show_sprites != Global.debilited:
		sprite_delay_timer += delta
		if sprite_delay_timer >= 0.7:
			should_show_sprites = Global.debilited
			$Sprites.visible = should_show_sprites
			sprite_delay_timer = 0.0
	else:
		sprite_delay_timer = 0.0
