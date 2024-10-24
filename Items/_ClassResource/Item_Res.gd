extends Resource
class_name Item_source

#poner aqui todo los atributos para nuestro items
@export var name : String
@export var description : String
@export var image : Texture #path de la imagen

@export var habilitie1 : String
@export var habilitie2 : String
@export var habilitie3 : String

@export var damage: String
@export var health: String

@export var quote : String #para poner lore de la carata

enum color {WHITE, BLACK, GREEN, RED, BLUE, COLORLESS}
@export var color_card: color

enum Card_type {CREATURE, ENCHANTMENT, INSTANT, MANA, ARTIFACT}
@export var card_type: Card_type

@export var foil : bool
