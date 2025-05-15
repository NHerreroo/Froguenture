extends Item

func _ready():
	entryCard() 
	setSorurceParam()
	
	connect("item_pressed", Callable(self, "_on_item_pressed"))

func _on_item_pressed():
	ApplyItems.increase_baseAtack(0.5)
	ApplyItems.decrease_speed(0.5)
