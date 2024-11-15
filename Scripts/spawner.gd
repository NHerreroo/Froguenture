extends Node3D

var enemie = preload("res://Scenes/Enemies/EnemyTemplate.tscn")
var num1
var num2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while true:
		await get_tree().create_timer(3).timeout
		get_random_pos()
		var enemigo = enemie.instantiate()
		get_random_pos()
		enemigo.position = Vector3(num1, 0 ,num2)
		get_tree().root.add_child(enemigo)
		

func get_random_pos():
	num1 = randi_range(-3.5, 4)
	num2 = randi_range(7, -7)
