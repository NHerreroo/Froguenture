extends Node3D

var slime = preload("res://Scenes/Enemies/Slime_Purple.tscn")
var rock = preload("res://Scenes/Enemies/RockBoy.tscn")
var mole = preload("res://Scenes/Enemies/Mole.tscn")
var fishy = preload("res://Scenes/Enemies/FishyBoy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var randEnem = randi_range(1,4)
	
	match randEnem:
		1:
			spawnSlime()
		2:
			spawnRock()
		3:
			spawnMole()
		4:
			spawnFish()
		_:
			spawnSlime()

func spawnSlime():
	var slimeInst = slime.instantiate()
	slimeInst.position = Vector3(0, 0 ,0)
	get_tree().root.add_child(slimeInst)


func spawnRock():
	var rockInst = rock.instantiate()
	rockInst.position = Vector3(0, 0 ,0)
	get_tree().root.add_child(rockInst)
	
func spawnMole():
	var moleInst = mole.instantiate()
	moleInst.position = Vector3(0, 0 ,0)
	get_tree().root.add_child(moleInst)
	
func spawnFish():
	var fishInst = fishy.instantiate()
	fishInst.position = Vector3(0, 0 ,0)
	get_tree().root.add_child(fishInst)
