extends Node

# posiciones del jugador real en la matrz del mapa, esta ira cambiando mientras pase por las puertas
# se utiliza para ver la posicion y generar la habitacion empieza en 5 por que el mapa siempre es de 10, 5 indica el centro siempre empieza ahi
var playerMapPositionX = 5
var playerMapPositionY = 5

var isMapGenerated = false
var eraseLevel = false

var map = [] #contiene el mapa generado para que al reinicial la escena no se pierda
