extends Node3D

var altarSeed = preload("res://Scenes/SeedAltar.tscn")
var ended = false


# Variables para la vida del enemigo
var max_health: float = 100.0  # Vida máxima del enemigo
var health_bar_max_width: float = 809.0  # Tamaño máximo de la barra en X

# Referencia al NinePatchRect
var health_bar: NinePatchRect
var animation_player: AnimationPlayer
var last_debilited_state: bool = false

func _ready() -> void:
	animation_player = $AnimationPlayer
	
	last_debilited_state = Global.debilited
	
func _process(_delta: float) -> void:
	if Global.enemies_remaining <= 0:
		play_end_flash()
		
	
	# Detectar cambios en Global.debilited
	if Global.debilited != last_debilited_state:
		if Global.debilited:
			animation_player.play("flash")  # Animación para cuando se debilita
		else:
			animation_player.play("flash")    # Animación para cuando se recupera
		
		# Actualizar el último estado conocido
		last_debilited_state = Global.debilited

func play_end_flash() -> void:
	if ended == false:
		if animation_player.has_animation("end"):
			animation_player.play("end")
			$AudioStreamPlayer2.play()
			$AudioStreamPlayer.stop()
			spawnSeed()
			Global.enemies_remaining -=1
			ended = true

func spawnSeed():
	var newAltar = altarSeed.instantiate()
	newAltar.position = Vector3(-2,0,0)
	add_child(newAltar)
