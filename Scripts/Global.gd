extends Node

var controller_active = false #el nombre lo dice todo AJAJA
var is_game_paused = false 
var card_focused = false

# posiciones del jugador real en la matrz del mapa, esta ira cambiando mientras pase por las puertas
# se utiliza para ver la posicion y generar la habitacion empieza en 25 por que el mapa siempre es de 50, el 25 indica el centro siempre empieza ahi
var playerMapPositionX = 25
var playerMapPositionY = 25

#bool para saber si se ha generado el mapa y no volver a generar hasta q se pase el boss
#el errase level es para desinstanciar la habitación y las puertas y volver a generarlas
var isMapGenerated = false
var eraseLevel = false

#funciones globales para hacer trigger de las collsiones en caso de no haber habitaciones a los lados (uso solo en el MainScrip que genera el mapa)
var topCollider = false
var botCollider = false
var rightCollider = false
var leftCollider = false


var map = [] #contiene el mapa generado para que al reinicial la escena no se pierda

var playerDirection = 4; # lo uso para saber la direccion en la que aprece en una sala, modifico esta variable entrando en puertas
# 0 = arriba, 1 abajo, 2 izaquierda, 3 derecha 4 = centro y para saber la direccion en la que esta mirando el jugador


var pointer_click = false #cuando esta en el mapa si se pulsa X con mando se pone true pero se vuelve a poner en false (solo al tocar)

#todo el rato me va a comprobar si estoy usando mando o teclado para cambiar la variable global
func _ready():
	Input.connect("joy_connection_changed", Callable(self, "_on_joy_connection_changed"))

func _on_joy_connection_changed(device_id, connected):
	if connected:
		controller_active = true
	else:
		controller_active = false
