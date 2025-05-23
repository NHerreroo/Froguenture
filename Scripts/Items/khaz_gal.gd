extends Item

func _ready():
	entryCard() #funcs que tiene la clase item para preparar el item a partir del source (los pongo aqui en lugar de la clase por q falla XD)
	setSorurceParam()
	
	connect("item_pressed", Callable(self, "_on_item_pressed"))

func _on_item_pressed():
	ApplyItems.increase_baseAtack(2.0)
	ApplyItems.decrease_attack_speed(0.3)
	ApplyItems.increase_speed(0.5)
