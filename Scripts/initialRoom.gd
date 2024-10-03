extends Node3D

@onready var TreeBG1 = $TreeBG
@onready var TreeBG2 = $TreeBG2
@onready var TreeBG3 = $TreeBG3
@onready var TreeBG4 = $TreeBG4


func _ready():
	playAnimations()
	
func _process(delta):
	if Global.eraseLevel == true:
		queue_free()


func playAnimations():
	TreeBG1.play("default")
	TreeBG2.play("default")
