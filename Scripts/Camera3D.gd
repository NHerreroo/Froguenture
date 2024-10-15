extends Camera3D

var player = null  # Referencia al nodo del jugador

var start_positionX = 7
var start_positionZ = 0

var followPlayer = false

func _ready():
	#espera leve para dejar cargar al jugador
	await get_tree().create_timer(0.2).timeout
	# Busca al jugador en el árbol de nodos
	player = get_tree().get_root().find_child("player", true, false)

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "position", Vector3(player.position.x + start_positionX, 8, 0), 1.0)

	await get_tree().create_timer(1.5).timeout
	followPlayer = true

func _process(delta):
	move_camera_to_player()
	if Global.eraseLevel == true:
		self.queue_free()
		
func move_camera_to_player(): #mueve la cam al player con un Linera interpolation(sauvizado)
	if followPlayer == true:
		self.position.z = lerp(self.position.z, player.position.z, 0.05)  # Lerp para el eje Z
		self.position.x = lerp(self.position.x, player.position.x + start_positionX, 0.05)  # Lerp para el eje X
