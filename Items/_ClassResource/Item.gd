extends Resource
class_name Item

#poner aqui todo los atributos para nuestro items
@export var name : String
@export var description : String
@export var image : Texture #path de la imagen

@export var habilitie1 : String
@export var habilitie2 : String
@export var habilitie3 : String

@export var quote : String #para poner lore de la carata

enum color {WHITE, BLACK, GREEN, RED, BLUE}
@export var color_player: color

enum Card_type {CREATURE, ENCHANTMENT, INSTANT, MANA, ARTIFACT}
@export var card_type: Card_type
