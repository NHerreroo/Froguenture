extends Area2D

var pointer_speed = 40
var target_position: Vector2
var input_dir

#topes de la pantalla
var min_x = -3407
var max_x = 3388

var min_y = -1377
var max_y = 1277

func _ready():
	target_position = position


#func para mover el pointer si el controlador esta activo
func move_pointer(): 
	if Global.controller_active:
		input_dir = Input.get_vector("Keyboard_A", "Keyboard_D", "Keyboard_W", "Keyboard_S")
		target_position += input_dir * pointer_speed

#muestra o oculta el puntero dependiendo de como jueges y llama a sus funciones ademas de controlar los limites
func _process(delta):
	if not Global.controller_active: 
		disable_pointer()
	else:
		enable_pointer()
		move_pointer()
		position = position.lerp(target_position, 0.3)
	control_limits()

#hace un clamp para limitar que se salga el puntero de la pantalla ademas de actulizar posicion si se esta saliendo
func control_limits():
	position.x = clamp(position.x, -3407, 3388)
	position.y = clamp(position.y, -1377, 1277)
	if target_position.x < min_x:
		target_position.x = min_x
	elif target_position.x > max_x:
		target_position.x = max_x

	if target_position.y < min_y:
		target_position.y = min_y
	elif target_position.y > max_y:
		target_position.y = max_y

#funcs para ocultar y mostrar
func enable_pointer():
	self.show()
	$CollisionShape2D.disabled

func disable_pointer():
	self.hide()
	$CollisionShape2D.disabled


#para jugadores de mando
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		Global.pointer_click = true
	else:
		Global.pointer_click = false
