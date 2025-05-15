extends Item

func _ready():
	entryCard() 
	setSorurceParam()
	
	connect("item_pressed", Callable(self, "_on_item_pressed"))

func _on_item_pressed():
	ApplyItems.increase_Maxhealth(1)
	ApplyItems.increase_health(1)
	ApplyItems.decrease_attack_speed(0.1)
