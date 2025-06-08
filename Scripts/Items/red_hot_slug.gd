extends Item

func _ready():
	entryCard() #funcs que tiene la clase item para preparar el item a partir del source (los pongo aqui en lugar de la clase por q falla XD)
	setSorurceParam()
	
	connect("item_pressed", Callable(self, "_on_item_pressed"))

func _on_item_pressed():
	ApplyItems.increase_Maxhealth(2)
	ApplyItems.increase_baseAtack(0.3)
	Player.notify_health_updated()
