extends Camera3D

var player = null  # Referencia al nodo del jugador

var start_positionX = 7.0
var start_positionY = 8.0
var start_positionZ = 0.0

var followPlayer = false

func _ready():
	self.position = Vector3(start_positionX,start_positionY,start_positionZ)
	#espera leve para dejar cargar al jugador
	await get_tree().create_timer(0.1).timeout
	# Busca al jugador en el árbol de nodos
	player = get_tree().get_root().find_child("player", true, false)

	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self, "position", Vector3(start_positionX, 7, 0), 1.0)
	await get_tree().create_timer(1.5).timeout

	followPlayer = true

func _process(delta):
	if Global.eraseLevel == true:
		self.queue_free()

	if Global.dialog_ended:
		move_camera_to_player()
	else:
		move_camera_to_initial()


		
func move_camera_to_player(): #mueve la cam al player con un Linera interpolation(sauvizado)
	if followPlayer == true:
		self.position.z = lerp(self.position.z, player.position.z, 0.05)  # Lerp para el eje Z
		self.position.x = lerp(self.position.x, player.position.x + start_positionX, 0.05)  # Lerp para el eje X
		self.position.y = lerp(self.position.y, start_positionY - 1, 0.03)
func move_camera_to_initial():
	self.position.z = lerp(self.position.z, start_positionZ, 0.03)
	self.position.x = lerp(self.position.x, start_positionX, 0.03)
	self.position.y = lerp(self.position.y, start_positionY, 0.03)



func get_random_shake_seed_x(min: float, max: float) -> float:
	return randf_range(min, max)

func low_shake_camera():
	var target_h_offset = 0.0
	var target_v_offset = 0.0

	for x in 5:
		target_h_offset = get_random_shake_seed_x(-0.1, 0.1)
		target_v_offset = get_random_shake_seed_x(-0.1, 0.1)
		
		self.h_offset = lerp(self.h_offset, target_h_offset, 0.5)
		self.v_offset = lerp(self.v_offset, target_v_offset, 0.5)
		
		await get_tree().create_timer(0.04).timeout

	# Vuelve a cero al terminar
	self.h_offset = lerp(self.h_offset, 0.0, 0.5)
	self.v_offset = lerp(self.v_offset, 0.0, 0.5)
	
	
func big_shake_camera():
	var target_h_offset = 0.0
	var target_v_offset = 0.0

	for x in 5:
		target_h_offset = get_random_shake_seed_x(-0.3, 0.3)
		target_v_offset = get_random_shake_seed_x(-0.3, 0.3)
		
		self.h_offset = lerp(self.h_offset, target_h_offset, 0.5)
		self.v_offset = lerp(self.v_offset, target_v_offset, 0.5)
		
		await get_tree().create_timer(0.04).timeout

	# Vuelve a cero al terminar
	self.h_offset = lerp(self.h_offset, 0.0, 0.5)
	self.v_offset = lerp(self.v_offset, 0.0, 0.5)
	
func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1
