extends Node

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
# 0 = arriba, 1 abajo, 2 izaquierda, 3 derecha 4 = centro

