extends Node3D

var player = null

func _ready():
	player = get_tree().get_root().find_child("player", true, false)
	setPlayerPosition(Global.playerDirection)

func _process(delta):
	if Global.eraseLevel == true:
		queue_free()


func setPlayerPosition(position: int):
	match position:
		0: #arriba
			player.position = Vector3(4.038,0.014,-0.207) 
		1: #abajo
			player.position = Vector3(-3.962,0.014,-0.207)
		2: #Izqui
			player.position = Vector3(0.038, 0.014, -7.707)
		3: #derch
			player.position = Vector3(0.038,0.014,7.793)
		4: #mitad (solo inicio partida)
			player.position = Vector3(2.638, 0.014, -0.207)
