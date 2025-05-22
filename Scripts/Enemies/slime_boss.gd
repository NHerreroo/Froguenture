extends Node3D

var altarSeed = preload("res://Scenes/SeedAltar.tscn")

# Variables para la vida del enemigo
var max_health: float = 100.0  # Vida máxima del enemigo
var health_bar_max_width: float = 809.0  # Tamaño máximo de la barra en X
var health_bar: NinePatchRect


func _ready() -> void:
	Global.defeated = false

func _process(_delta: float) -> void:
	if Global.enemies_remaining == 0:
		$AudioStreamPlayer2.play()
		$AudioStreamPlayer.stop()
		Global.defeated = true
		$AnimationPlayer.play("end")
		spawnSeed()
		Global.enemies_remaining = 1


func spawnSeed():
	var newAltar = altarSeed.instantiate()
	newAltar.position = Vector3(-2,0,0)
	add_child(newAltar)
