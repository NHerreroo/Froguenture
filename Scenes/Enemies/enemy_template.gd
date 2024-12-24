extends Enemy

var bullet = preload("res://Scenes/Enemies/EnemyBullet.tscn")


func _ready() -> void:
	Global.enemies_remaining += 1
	get_random_state()
	while true:
		await get_tree().create_timer(1).timeout
		shoot_in_four_directions()
		
	

func shoot_in_four_directions():
	var directions = [
		Vector3(0, 0, -1),  # Adelante
		Vector3(0, 0, 1),   # Atrás 
		Vector3(-1, 0, 0),  # Izquierda 
		Vector3(1, 0, 0)    # Derecha 
	]
	
	for direction in directions:
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_transform.origin = self.global_transform.origin
		bullet_instance.direction = direction
		get_tree().root.add_child(bullet_instance)
